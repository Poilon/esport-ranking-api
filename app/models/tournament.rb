class Tournament < ApplicationRecord

  has_many :results
  belongs_to :game

  validates :smashgg_id, uniqueness: true

  def self.total_pages
    <<~STRING
      query TournamentsQuery {
        tournaments(query: {page: 1, perPage: 75, sortBy: "endAt asc", filter: { past: true, afterDate: 1577833200, videogameIds: [1] }  }){
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
        tournaments(query: {page: #{page}, perPage: 75, sortBy: "endAt asc", filter: { past: true, afterDate: 1577833200, videogameIds: [1] }  }){
          pageInfo {
            totalPages
          }
          nodes {
            id
            name
            endAt
            events {
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

  def self.results_query(id)
    <<~STRING
      query EventQuery {
        event(id: #{id}) {
          standings(query: {page: 1, perPage: 500}) {
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

  def self.import_tournament_results
    tournament_ids = Tournament.pluck(:smashgg_id) - Tournament.joins(:results).uniq.pluck(:smashgg_id)
    count = tournament_ids.count
    tournament_ids.each do |smashgg_id|
      puts count
      count -= 1

      next if count > 131

      begin
        event = HTTParty.post(
          'https://api.smash.gg/gql/alpha',
          body: { query: results_query(smashgg_id) },
          headers: { Authorization: "Bearer #{ENV['SMASHGG_API_TOKEN']}" }
        )
      rescue
        next
      end
      sleep(1)

      next unless event['data']

      next unless event['data']['event']

      event = event['data']['event']

      next unless event['standings']
      next unless event['standings']['nodes']

      puts "#{event['standings']['nodes'].count} results to enter"

      next if event['standings']['nodes'][0] && event['standings']['nodes'][0]['placement'].zero?

      event['standings']['nodes'].each do |standing|

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

  def self.import_from_smashgg
    game_id = Game.find_by(smashgg_id: 1).id

    pages_number = HTTParty.post(
      'https://api.smash.gg/gql/alpha',
      body: { query: total_pages },
      headers: { Authorization: "Bearer #{ENV['SMASHGG_API_TOKEN']}" }
    )

    pages_number['data']['tournaments']['pageInfo']['totalPages'].times do |i|

      sleep(1)
      tournaments = HTTParty.post(
        'https://api.smash.gg/gql/alpha',
        body: { query: query(i + 1) },
        headers: { Authorization: "Bearer #{ENV['SMASHGG_API_TOKEN']}" }
      )
      tournaments['data']['tournaments']['nodes'].each do |tournament|
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
  end

end
