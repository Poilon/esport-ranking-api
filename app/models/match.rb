class Match < ApplicationRecord

  belongs_to :tournament
  belongs_to :winner, class_name: 'Player', foreign_key: 'winner_player_id'
  belongs_to :loser, class_name: 'Player', foreign_key: 'loser_player_id'

  def self.matchs_total_pages(id)
    <<~STRING
      query MatchesTotalPagesQuery {
        event(id: #{id}) {
          sets(page: 1, perPage: 50) {
            pageInfo {
              totalPages
            }
          }
        }
      }
    STRING
  end

  def self.matchs_query(id, page)
    <<~STRING
      query MatchesQuery {
        event(id: #{id}) {
          sets(page: #{page}, perPage: 50) {
            pageInfo {
              totalPages
            }
            nodes {
              id
              completedAt
              winnerId
              vodUrl
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

  def self.import_all_matches
    Tournament.pluck(:smashgg_id).each do |smashgg_event_id|
      import_match_of_tournament_from_smashgg(smashgg_event_id)
    end
  end

  def self.import_match_of_tournament_from_smashgg(smashgg_event_id)
    total_pages = query_smash_gg(matchs_total_pages(smashgg_event_id)).dig('data', 'event', 'sets', 'pageInfo', 'totalPages')

    (total_pages || 0).times do |page|
      matchs = query_smash_gg(matchs_query(smashgg_event_id, page + 1)).dig('data', 'event', 'sets', 'nodes')
      matchs.each do |m|
        next if m['displayScore'] == 'DQ'

        player_ids = m.dig('slots')&.each_with_object({}) do |s, h|
          h[s.dig('entrant', 'id')] = s.dig('entrant', 'participants')&.first
        end
        winner_player = player_ids.dig(m['winnerId'])
        loser_player =  player_ids.reject { |k, _| k == m['winnerId'] }&.values&.first

        winner_params = {
          smashgg_id: winner_player.dig('player', 'id'),
          name: winner_player.dig('player', 'gamerTag'),
          smashgg_user_id: winner_player.dig('user', 'id')
        }

        loser_params = {
          smashgg_id: loser_player.dig('player', 'id'),
          name: loser_player.dig('player', 'gamerTag'),
          smashgg_user_id: loser_player.dig('user', 'id')
        }
        winner = Player.find_by(smashgg_id: winner_player.dig('player', 'id'))
        winner ? winner.update(winner_params) : Player.create(winner_params)

        loser = Player.find_by(smashgg_id: loser_player.dig('player', 'id'))
        loser ? loser.update(loser_params) : Player.create(loser_params)

        params = {
          smashgg_id: m['id'],
          tournament_id: Tournament.find_by(smashgg_id: smashgg_event_id)&.id,
          winner_player_id: winner.id,
          loser_player_id: loser.id,
          vod_url: m['vod_url']
        }
        db_match = Match.find_by(smashgg_id: m['id'])
        db_match ? db_match.update(params) : Match.create(params)
      end
    end
  end

end
