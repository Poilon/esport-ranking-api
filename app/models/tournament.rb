class Tournament < ApplicationRecord

  has_many :matches, dependent: :destroy
  has_many :results, dependent: :destroy
  belongs_to :game

  def self.import_year_by_year
    (2015..Time.now.year).each do |year|
      import_from_smashgg(Date.parse("#{year}-01-01").to_time.to_i)
    end
  end

  def self.import_tournament_results_and_matchs_from_smashgg
    tournament_ids = Match.joins(:tournament).deep_pluck(
      tournament: %i[id smashgg_id]
    ).uniq.map do |e|
      [e[:tournament]['id'], e[:tournament]['smashgg_id']]
    end

    bar = ProgressBar.new(tournament_ids.count)

    tournament_ids.each do |id, smashgg_id|
      bar.increment!
      find(id).results.destroy_all
      find(id).matches.destroy_all

      import_tournament_results(smashgg_id)
      import_matches_of_tournament_from_smashgg(smashgg_id)
    end
  end

  def self.import_tournament_results(smashgg_id, bar = nil)
    bar&.increment!

    sleep(1)
    event = query_smash_gg(result_query(smashgg_id, 1)).dig('data', 'event')

    find_by(smashgg_id: smashgg_id).update(processed: true)
    return if !event || event.dig('state') != 'COMPLETED'

    pages_count = event.dig('standings', 'pageInfo', 'totalPages') || 0
    pages_count.times do |page|
      standings = query_smash_gg(result_query(smashgg_id, page + 1)).dig('data', 'event', 'standings', 'nodes') || []
      standings.each do |s|
        player = s.dig('entrant', 'participants')&.first&.try(:[], 'player')
        next unless player

        params = { smashgg_id: player['id'], name: player['gamerTag'] }
        p = Player.find_by(smashgg_id: player['id']) ||
          Player.find_by(smashgg_user_id: player.dig('user', 'id')) ||
          Player.create(params)

        Result.find_or_create_by(
          player_id: p.id, tournament_id: find_by(smashgg_id: smashgg_id).id, rank: s['placement']
        )
      end
    end
  end

  def self.import_tournaments_results
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    tournaments = Tournament.where('date > ?', Date.parse('2020-02-02'))

    tournament_ids = tournaments.pluck(:smashgg_id) - tournaments.joins(:results).pluck(:smashgg_id)
    tournament_ids.uniq!
    count = tournament_ids.count
    bar = ProgressBar.new(count)
    tournament_ids.each { |smashgg_id| import_tournament_results(smashgg_id, bar) }

    ActiveRecord::Base.logger = old_logger
  end

  def self.import_from_smashgg_id(smashgg_id)
    tournament = query_smash_gg(single_tournament_query(smashgg_id)).dig('data', 'tournament')
    game_id = Game.find_by(smashgg_id: 1).id

    return unless tournament

    tournament['events'].each do |event|

      next if event['type'] != 1
      next if event['videogame']['id'] != 1

      params = {
        smashgg_link_url: "https://smash.gg/#{event['slug']}",
        name: tournament['name'].to_s + ' - ' + event['name'].to_s,
        date: Time.at(tournament['endAt']),
        game_id: game_id,
        online: event['isOnline']
      }

      if (t = Tournament.find_by(smashgg_id: event['id']))
        t.update(params)
      else
        Tournament.create({ smashgg_id: event['id'] }.merge(params))
      end
    end.map { |e| e['id'] }
  end

  def self.import_from_smashgg(time = 1483225200)
    game_id = Game.find_by(smashgg_id: 1).id
    begin
      pages_number = query_smash_gg(tournaments_total_pages(time)).dig('data', 'tournaments', 'pageInfo', 'totalPages')
    rescue e
      retry
    end
    old_logger = ActiveRecord::Base.logger
    bar = ProgressBar.new(pages_number)
    ActiveRecord::Base.logger = nil
    pages_number.times do |i|
      bar.increment!
      sleep(1)
      begin
        tournaments = query_smash_gg(query(i + 1, time)).dig('data', 'tournaments', 'nodes') || []
      rescue e
        binding.pry
        retry
      end
      tournaments.each do |tournament|

        (tournament['events'] || []).each do |event|

          next if event['type'] != 1
          next if event['videogame']['id'] != 1

          params = {
            smashgg_link_url: "https://smash.gg/#{event['slug']}",
            name: tournament['name'].to_s + ' - ' + event['name'].to_s,
            date: Time.at(tournament['endAt']),
            game_id: game_id,
            online: event['isOnline']
          }

          if (t = Tournament.find_by(smashgg_id: event['id']))
            t.update(params)
          else
            puts "NEW TOURNAMENT => #{params[:name]}"
            Tournament.create({ smashgg_id: event['id'] }.merge(params))
          end
        end
      end
    end
    ActiveRecord::Base.logger = old_logger
  end

  def self.import_matches_of_tournament_from_smashgg(smashgg_event_id)
    sleep(1)
    total_pages = query_smash_gg(matchs_total_pages(smashgg_event_id, 60)).dig(
      'data', 'event', 'sets', 'pageInfo', 'totalPages'
    )

    puts "#{total_pages.to_i * 60} matches to import for #{smashgg_event_id} "

    (total_pages || 0).times do |page|
      sleep(1)
      matchs = query_smash_gg(matchs_query(smashgg_event_id, page + 1, 60)).dig('data', 'event', 'sets', 'nodes') || []

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

  def self.tournaments_total_pages(time=1483225200)
    <<~STRING
      query TournamentsQuery {
        tournaments(query: { page: 1, perPage: 75, sortBy: "endAt asc", filter: {afterDate: #{time}, videogameIds: [1]} }){
          pageInfo {
            totalPages
          }
        }
      }
    STRING
  end

  def self.single_tournament_query(tournament_id)
    <<~STRING
      query SingleTournamentQuery {
        tournament(id: "#{tournament_id}") {
          id
          name
          endAt
          events {
            state
            id
            isOnline
            name
            slug
            type
            videogame {
              id
              name
            }
          }
        }
      }
    STRING
  end

  def self.query(page, time=1483225200)
    <<~STRING
      query TournamentsQuery {
        tournaments(query: {page: #{page}, perPage: 75, sortBy: "endAt asc", filter: {afterDate: #{time}, videogameIds: [1]}}){
          pageInfo {
            totalPages
          }
          nodes {
            id
            name
            endAt
            events {
              state
              id
              isOnline
              name
              slug
              type
              videogame {
                id
                name
              }
            }
          }
        }
      }
    STRING
  end

  def self.result_query(id, page)
    <<~STRING
      query EventQuery {
        event(id: #{id}) {
          state
          standings(query: {page: #{page}, perPage: 100}) {
            pageInfo {
              totalPages
            }
            nodes {
              placement
              entrant {
                participants {
                  player {
                    id
                    prefix
                    gamerTag
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
    STRING
  end

  def self.result_query_with_phases(id, page)
    <<~STRING
      query EventQuery {
        event(id: #{id}) {
          phaseGroups {
            state
            phase {
              bracketType
              name
            }
            standings(query: {page: #{page}, perPage: 10}) {
              pageInfo {
                totalPages
              }
              nodes {
                placement
                entrant {
                  participants {
                    player {
                      id
                      prefix
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

end
