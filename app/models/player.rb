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
          authorizations {
            externalUsername
            type
            url
          }
          location {
            country
            state
            city
          }
          images {
            id
            type
            url
          }
          player {
            prefix
            gamerTag
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

  def self.hydrate_players_info
    Player.where('smashgg_user_id is not null and country is null').each do |player|
      smashgg_user_id = player.smashgg_user_id
      puts smashgg_user_id
      sleep(1)
      begin
        smashgg_user = query_smash_gg(user_query(smashgg_user_id))
      rescue
        next
      end
      puts smashgg_user.dig('data', 'user', 'player', 'gamerTag')

      params = {
        current_mpgr_ranking: smashgg_user.dig('data', 'user', 'player', 'rankings')&.reject do |r|
          r['title'] != 'MPGR: 2019 MPGR'
        end.try(:[], 0).try(:[], 'rank'),
        country: smashgg_user.dig('data', 'user', 'location', 'country'),
        state: smashgg_user.dig('data', 'user', 'location', 'state'),
        city: smashgg_user.dig('data', 'user', 'location', 'city'),
        profile_picture_url: smashgg_user.dig('data', 'user', 'images')&.reject do |i|
          i['type'] != 'profile'
        end.try(:[], 0).try(:[], 'url'),
        twitter: smashgg_user.dig('data', 'user', 'authorizations')&.reject do |i|
          i['type'] != 'TWITTER'
        end.try(:[], 0).try(:[], 'url'),
        twitch: smashgg_user.dig('data', 'user', 'authorizations')&.reject do |i|
          i['type'] != 'TWITCH'
        end.try(:[], 0).try(:[], 'url'),
        mixer: smashgg_user.dig('data', 'user', 'authorizations')&.reject do |i|
          i['type'] != 'MIXER'
        end.try(:[], 0).try(:[], 'url'),
        discord: smashgg_user.dig('data', 'user', 'authorizations')&.reject do |i|
          i['type'] != 'DISCORD'
        end.try(:[], 0).try(:[], 'externalUsername'),
        steam: smashgg_user.dig('data', 'user', 'authorizations')&.reject do |i|
          i['type'] != 'STEAM'
        end.try(:[], 0).try(:[], 'externalUsername')
      }.reject { |_, v| v.blank? }

      player.update(params)
    end
  end

  def self.reset_elo
    puts 'Are you sure ? yes to accept'
    res = gets.strip
    return if res != 'y' && res != 'yes'

    Player.update_all(elo: 1500)
    Player.update_all(current_mpgr_ranking: nil)
  end

end
