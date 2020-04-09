class Match < ApplicationRecord

  belongs_to :tournament
  belongs_to :winner, class_name: 'Player', foreign_key: 'winner_player_id'
  belongs_to :loser, class_name: 'Player', foreign_key: 'loser_player_id'

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

  def self.reset!
    Match.update_all(played: false)
    Player.update_all(elo: 1500)
    Player.where('current_mpgr_ranking is not null').each do |p|
      p.update(elo: 2100 - p.current_mpgr_ranking * 5)
    end
  end

  def self.run
    bar = ProgressBar.new(where(played: false).count)
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    EloRating.k_factor = 40
    joins(:tournament).order('tournaments.date desc').where(played: false).joins(:tournament).order('tournaments.date asc').each do |match|
      match.adjust_elo
      bar.increment!
    end
    ActiveRecord::Base.logger = old_logger
  end

  def adjust_elo
    return if played == true

    EloRating.k_factor = is_loser_bracket ? 20 : 40

    m = EloRating::Match.new
    m.add_player(rating: loser.elo)
    m.add_player(rating: winner.elo, winner: true)
    new_ratings = m.updated_ratings
    loser.update_attribute(:elo, new_ratings[0])
    winner.update_attribute(:elo, new_ratings[1])
    update_attribute(:played, true)
  end

  def self.import_all_matches
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    tournament_ids = Tournament.where(imported_matches: false).joins(:results).pluck(:smashgg_id).uniq
    bar = ProgressBar.new(tournament_ids.count)

    tournament_ids.each do |smashgg_event_id|
      bar.increment!
      import_matches_of_tournament_from_smashgg(smashgg_event_id)
      Tournament.find_by(smashgg_id: smashgg_event_id)&.update(imported_matches: true)
    end

    ActiveRecord::Base.logger = old_logger
  end

  def self.import_matches_of_tournament_from_smashgg(smashgg_event_id)
    total_pages = query_smash_gg(matchs_total_pages(smashgg_event_id, 80)).dig('data', 'event', 'sets', 'pageInfo', 'totalPages')

    (total_pages || 0).times do |page|
      sleep(1)
      matchs = query_smash_gg(matchs_query(smashgg_event_id, page + 1, 80)).dig('data', 'event', 'sets', 'nodes') || []
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
          smashgg_user_id: winner_player.dig('user', 'id')
        }

        loser_params = {
          smashgg_id: loser_player.dig('player', 'id'), name: loser_player.dig('player', 'gamerTag'),
          smashgg_user_id: loser_player.dig('user', 'id')
        }
        winner = Player.find_by(smashgg_id: winner_player.dig('player', 'id'))
        winner ? winner.update(winner_params) : winner = Player.create(winner_params)

        loser = Player.find_by(smashgg_id: loser_player.dig('player', 'id'))
        loser ? loser.update(loser_params) : loser = Player.create(loser_params)

        params = {
          smashgg_id: m['id'], tournament_id: Tournament.find_by(smashgg_id: smashgg_event_id)&.id,
          winner_player_id: winner.id, loser_player_id: loser.id, vod_url: m['vod_url'],
          is_loser_bracket: m['round']&.negative?, display_score: m['displayScore'], full_round_text: m['fullRoundText']
        }
        db_match = Match.find_by(smashgg_id: m['id'])
        db_match ? db_match.update(params) : Match.create(params)
      end
    end
  end

end
