class Player < ApplicationRecord

  has_many :elo_by_times
  has_many :player_characters
  has_many :characters, through: :player_characters
  has_many :results
  has_many :player_teams
  has_many :teams, through: :player_teams
  has_many :winning_matches, class_name: 'Match', foreign_key: 'winner_player_id'
  has_many :losing_matches, class_name: 'Match', foreign_key: 'loser_player_id'

  def elo_map
    return [] unless elo_by_times.order('date asc').first

    start_date = elo_by_times.order('date asc').first.date.to_date
    end_date = Date.today

    number_of_months = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
    dates = number_of_months.times.each_with_object([]) do |count, array|
      array << start_date.beginning_of_month + count.months
    end
    hash = dates.each_with_object({}) do |e, h|
      h[e] = elo_by_times.min_by { |et| (et.date.to_time - e.to_time).abs }
    end.to_json
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

  def best_win
    winning_matches.joins(:loser).order('players.elo desc').first
  end

  def best_wins(number)
    winning_matches.joins(:loser).order('players.elo desc').first(number)
  end

  def worst_lose
    losing_matches.joins(:winner).order('players.elo asc').first
  end

  def self.hydrate_players_info
    players = Player.where('smashgg_user_id is not null and country is null').order(elo: :desc)

    bar = ProgressBar.new(players.count)
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    players.each do |player|
      smashgg_user_id = player.smashgg_user_id
      sleep(1)
      smashgg_user = query_smash_gg(user_query(smashgg_user_id))
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
      bar.increment!
    end
    ActiveRecord::Base.logger = old_logger
  end

end
