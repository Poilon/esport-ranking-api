class Tournament < ApplicationRecord

  has_many :matches
  has_many :results
  belongs_to :game

  def self.tournaments_total_pages
    <<~STRING
      query TournamentsQuery {
        tournaments(query: {page: 1, perPage: 75, sortBy: "endAt asc", filter: { past: true, videogameIds: [1] }  }){
          pageInfo {
            totalPages
          }
        }
      }
    STRING
  end

  def self.query(page)
    <<~STRING
      query TournamentsQuery {
        tournaments(query: {page: #{page}, perPage: 75, sortBy: "endAt asc", filter: { past: true, videogameIds: [1] }  }){
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

  def self.import_tournament_results
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    tournament_ids = Tournament.where(processed: false).pluck(:smashgg_id) - Tournament.joins(:results).uniq.pluck(:smashgg_id)
    bar = ProgressBar.new(tournament_ids.count)

    tournament_ids.each do |smashgg_id|
      bar.increment!

      event = query_smash_gg(result_query(smashgg_id, 1)).dig('data', 'event')
      Tournament.find_by(smashgg_id: smashgg_id).update(processed: true)
      next if !event || event.dig('state') != 'COMPLETED'

      pages_count = event.dig('standings', 'pageInfo', 'totalPages') || 0
      pages_count.times do |page|

        standings = query_smash_gg(result_query(smashgg_id, page + 1)).dig('data', 'event', 'standings', 'nodes') || []
        standings.each do |s|
          player = s.dig('entrant', 'participants')&.first&.try(:[], 'player')
          next unless player

          params = { smashgg_id: player['id'], name: player['gamerTag'] }
          p = Player.find_by(smashgg_id: player['id']) || Player.create(params)
          Result.find_or_create_by(
            player_id: p.id, tournament_id: Tournament.find_by(smashgg_id: smashgg_id).id, rank: s['placement']
          )
        end
      end
    end

    ActiveRecord::Base.logger = old_logger
  end

  def self.import_tournament_results_by_phase
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    tournament_ids = Tournament.pluck(:smashgg_id) - Tournament.joins(:results).uniq.pluck(:smashgg_id)

    count = tournament_ids.count

    tournament_ids.each do |smashgg_id|
      puts count
      count -= 1

      pages_count = query_smash_gg(results_query(smashgg_id, 1)).dig('data', 'event', 'phaseGroups','standings', 'pageInfo', 'totalPages') || 0

      pages_count.times do |page|
        begin
          events = query_smash_gg(Tournament.results_query(smashgg_id, page + 1))
        rescue
          next
        end

        sleep(1)

        next unless events['data']

        next unless events['data']['event']

        next if events['data']['event']['phaseGroups'].blank?

        phase_groups = events['data']['event']['phaseGroups'].select do |pg|
          pg['phase'] &&
            pg['phase']['bracketType'] == 'DOUBLE_ELIMINATION' && pg['standings'] &&
            pg['standings']['nodes'] &&
            pg['standings']['nodes'].map { |n| n['placement'] }.include?(1) &&
            !pg['phase']['name'].downcase.include?('amateur') &&
            !pg['phase']['name'].downcase.include?('pools') &&
            !pg['phase']['name'].downcase.include?('ladder') &&
            pg['state'] == 3
        end

        event = phase_groups.first

        next if event.blank?
        next unless event['standings']
        next unless event['standings']['nodes']

        puts "#{event['standings']['nodes'].count} results to enter"

        next if event['standings']['nodes'][0] && event['standings']['nodes'][0]['placement'].zero?

        event['standings']['nodes'].each do |standing|
          next unless standing['entrant']
          next unless standing['entrant']['participants']
          next unless standing['entrant']['participants'].first

          player = standing['entrant']['participants'].first['player']

          next unless player

          params = {
            name: player['gamerTag']
          }

          if (p = Player.find_by(smashgg_id: player['id']))
            p.update(params)
          else
            p = Player.create({ smashgg_id: player['id'] }.merge(params))
          end

          next if Result.find_by(tournament_id: Tournament.find_by(smashgg_id: smashgg_id).id, player_id: p.id)

          Result.create(player_id: p.id, tournament_id: Tournament.find_by(smashgg_id: smashgg_id).id, rank: standing['placement'])
        end
      end
    end
    ActiveRecord::Base.logger = old_logger
  end

  def self.import_from_smashgg
    game_id = Game.find_by(smashgg_id: 1).id

    pages_number = query_smash_gg(
      tournaments_total_pages
    ).dig('data', 'tournaments', 'pageInfo', 'totalPages')

    old_logger = ActiveRecord::Base.logger
    bar = ProgressBar.new(pages_number)
    ActiveRecord::Base.logger = nil
    pages_number.times do |i|
      bar.increment!
      sleep(1)
      tournaments = query_smash_gg(query(i + 1)).dig('data', 'tournaments', 'nodes') || []

      tournaments.each do |tournament|
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
        end
      end
    end
    ActiveRecord::Base.logger = old_logger
  end

end
