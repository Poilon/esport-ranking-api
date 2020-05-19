class Match < ApplicationRecord

  has_many :elo_by_times
  belongs_to :tournament
  belongs_to :winner, class_name: 'Player', foreign_key: 'winner_player_id'
  belongs_to :loser, class_name: 'Player', foreign_key: 'loser_player_id'

  def self.reset!
    Match.update_all(played: false)
    Player.update_all(elo: 1500)
    EloByTime.delete_all
  end

  def self.reset_year(year)
    Match.joins(:tournament).where('tournaments.date > ?', Date.parse("#{year}-01-01")).update_all(played: false)
    EloByTime.where('date > ?', Date.parse("#{year}-01-01")).delete_all
    Player.find_each { |p| p.update(elo: p.elo_by_times.order(date: :desc).first&.elo || 1500) }
  end

  def self.run
    items = Tournament.where(online: false).joins(:matches).where(matches: { played: false }).order('date asc').distinct
    bar = ProgressBar.new(items.count)

    without_logs do
      items.each do |tournament|
        bar.increment!
        play_matches_of_tournament(tournament)
      end
    end
  end

  def self.play_matches_of_tournament(tournament)
    tournament.matches.order('ABS(round) asc').where(played: false).each(&:play_match)
  end

  def play_match
    return if played == true

    EloRating.k_factor = is_loser_bracket ? 20 : 40

    m = EloRating::Match.new
    m.add_player(rating: loser.elo)
    m.add_player(rating: winner.elo, winner: true)

    new_ratings = m.updated_ratings
    loser.update_attribute(:elo, new_ratings[0])
    loser.elo_by_times.create(elo: new_ratings[0], date: date, match_id: id)
    winner.update_attribute(:elo, new_ratings[1])
    winner.elo_by_times.create(elo: new_ratings[1], date: date, match_id: id)

    update_attribute(:played, true)
  end

  def self.import_all_matches
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    tournament_ids = Tournament.where(
      'date > ?', Date.parse('2020-03-01')
    ).order('date asc').joins(:results).pluck(:smashgg_id).uniq

    bar = ProgressBar.new(tournament_ids.count)

    tournament_ids.each do |smashgg_event_id|
      bar.increment!
      import_matches_of_tournament_from_smashgg(smashgg_event_id)
      Tournament.find_by(smashgg_id: smashgg_event_id)&.update(imported_matches: true)
    end

    ActiveRecord::Base.logger = old_logger
  end

  def self.import_matches_of_tournament_from_smashgg(smashgg_event_id)
    sleep(1)
    begin
      total_pages = query_smash_gg(matchs_total_pages(smashgg_event_id, 60)).dig(
        'data', 'event', 'sets', 'pageInfo', 'totalPages'
      )
    rescue
      puts 'retry...'
      retry
    end
    puts "#{total_pages.to_i * 60} matches to import for #{smashgg_event_id} "

    (total_pages || 0).times do |page|
      sleep(1)
      begin
        matchs = query_smash_gg(matchs_query(smashgg_event_id, page + 1, 60)).dig('data', 'event', 'sets', 'nodes') || []
      rescue
        puts 'retry...'
        retry
      end
      print '.'
      matchs.each do |m|


        next if m['displayScore'] == 'DQ'

        player_ids = m.dig('slots')&.each_with_object({}) do |s, h|
          h[s.dig('entrant', 'id')] = s.dig('entrant', 'participants')&.first
        end
        winner_player = player_ids.dig(m['winnerId'])
        loser_player =  player_ids.reject { |k, _| k == m['winnerId'] }&.values&.first

        next if !winner_player || !loser_player

        winner_params = {
          smashgg_id: winner_player.dig('player', 'id'), name: winner_player.dig('player', 'gamerTag'),
          smashgg_user_id: winner_player.dig('user', 'id'), prefix: winner_player.dig('player', 'prefix')
        }

        loser_params = {
          smashgg_id: loser_player.dig('player', 'id'), name: loser_player.dig('player', 'gamerTag'),
          smashgg_user_id: loser_player.dig('user', 'id'), prefix: winner_player.dig('player', 'prefix')
        }
        winner = Player.find_by(smashgg_id: winner_player.dig('player', 'id'))
        winner ? winner.update(winner_params) : winner = Player.create(winner_params)

        loser = Player.find_by(smashgg_id: loser_player.dig('player', 'id'))
        loser ? loser.update(loser_params) : loser = Player.create(loser_params)

        tournament = Tournament.find_by(smashgg_id: smashgg_event_id)

        params = {
          smashgg_id: m['id'], tournament_id: tournament&.id,
          winner_player_id: winner.id, loser_player_id: loser.id, vod_url: m['vod_url'],
          is_loser_bracket: m['round']&.negative?, display_score: m['displayScore'], full_round_text: m['fullRoundText'],
          round: m['round'], date: tournament&.date

        }
        db_match = Match.find_by(smashgg_id: m['id'])
        db_match ? db_match.update(params) : Match.create(params)
      end
    end
  end

  def self.matchs_total_pages(id, per_page)
    <<~STRING
      query MatchesTotalPagesQuery {
        event(id: #{id}) {
          sets(page: 1, perPage: #{per_page}) {
            pageInfo {
              totalPages
            }
          }
        }
      }
    STRING
  end

  def self.matchs_query(id, page, per_page)
    <<~STRING
      query MatchesQuery {
        event(id: #{id}) {
          sets(page: #{page}, perPage: #{per_page}) {
            pageInfo {
              totalPages
            }
            nodes {
              id
              completedAt
              winnerId
              vodUrl
              round
              fullRoundText
              displayScore
              slots {
                entrant {
                  id
                  participants {
                    user {
                      id
                    }
                    player {
                      id
                      gamerTag
                      prefix
                      user {
                        id
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    STRING
  end

end
