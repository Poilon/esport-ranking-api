class Player < ApplicationRecord

  has_many :player_characters
  has_many :characters, through: :player_characters
  has_many :results
  has_many :player_teams
  has_many :teams, through: :player_teams
  has_many :winning_matches, class_name: 'Match', foreign_key: 'winner_player_id'
  has_many :losing_matches, class_name: 'Match', foreign_key: 'loser_player_id'

  def self.compute
    all.map(&:compute)
  end

  def self.user_query(smashgg_user_id)
    <<~STRING
      query UserQuery {
        user(id: #{smashgg_user_id}) {
          player {
            prefix
            rankings(videogameId: 1) {
              rank
              title
            }
          }
        }
      }
    STRING
  end

  def compute
    results.each do |r|
      self.score += (r.tournament.weight / r.rank.to_f)
      save
    end
  end

  def self.reset_elo
    puts 'Are you sure ? yes to accept'
    res = gets.strip
    return if res != 'y' && res != 'yes'

    Player.update_all(elo: 1500)
    Player.update_all(current_mpgr_ranking: nil)

    Player.pluck(:smashgg_user_id).each do |smashgg_user_id|
      smashgg_user = query_smash_gg(user_query(smashgg_user_id))
      mpgr_ranking = smashgg_user.dig('data', 'user', 'player', 'rankings')&.reject do |r|
        r['title'] != 'MPGR: 2019 MPGR'
      end.try(:[], 0).try(:[], 'rank')
      Player.find_by(smashgg_user_id: smashgg_user_id).update(current_mpgr_ranking: mpgr_ranking)
    end
  end

end
