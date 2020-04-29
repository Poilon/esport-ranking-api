class Player < ApplicationRecord

  has_many :elo_by_times, dependent: :destroy
  has_many :player_characters, dependent: :destroy
  has_many :characters, through: :player_characters
  has_many :results, dependent: :destroy
  has_many :player_teams, dependent: :destroy
  has_many :teams, through: :player_teams
  has_many :winning_matches, class_name: 'Match', foreign_key: 'winner_player_id', dependent: :destroy
  has_many :losing_matches, class_name: 'Match', foreign_key: 'loser_player_id', dependent: :destroy

  def rank
    Player.order(elo: :desc).pluck(:id).index(id).to_i + 1
  end

  def country_rank
    return nil unless country

    Player.where(country: country).order(elo: :desc).pluck(:id).index(id).to_i + 1
  end

  def state_rank
    return nil if !state || !country

    Player.where(country: country, state: state).order(elo: :desc).pluck(:id).index(id).to_i + 1
  end

  def city_rank
    return nil if !country || !city

    if state
      Player.where(country: country, state: state, city: city).order(elo: :desc).pluck(:id).index(id).to_i + 1
    else
      Player.where(country: country, city: city).order(elo: :desc).pluck(:id).index(id).to_i + 1
    end
  end

  def tournaments_diffs
    return {}.to_json if elo_by_times.blank?

    groups = elo_by_times.order(created_at: :asc).deep_pluck(
      :elo, match: { tournament: :id }
    ).group_by { |e| e[:match][:tournament]['id'] }

    current_elo = 1500
    groups.each_with_object({}) do |(t_id, ebts), h|
      h[t_id] = { from: current_elo, to: ebts.last['elo'] }
      current_elo = ebts.last['elo']
    end.to_json
  end

  def elo_map
    return {}.to_json unless elo_by_times.order('date asc').first

    start_date = Date.parse('2015-01-01')
    end_date = Date.today

    number_of_months = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
    dates = number_of_months.times.each_with_object([]) do |count, array|
      array << start_date.beginning_of_month + count.months
    end

    arr = elo_by_times.order(created_at: :desc).deep_pluck(:date, :elo, :created_at)
    hash = dates.each_with_object({}) do |e, h|
      h[e] ||= arr.select { |ebt| ebt['date'] < e }.first || { elo: 1500, date: dates.first }
    end

    hash[Date.parse('2015-01-01')] = { elo: 1500, date: dates.first }
    hash[dates.last] = { elo: elo_by_times.order(created_at: :asc).last&.elo || 1500, date: dates.first }

    hash.sort_by { |k, _| k }.to_h.to_json
  end

  def self.undouble_players
    without_logs do
      where('smashgg_user_id is not null').order(elo: :desc).each do |p|

        players = Player.where(smashgg_user_id: p.smashgg_user_id)
        next if players.count == 1

        puts "#{p.name} - #{players.count}"

        players.each do |pp|
          next if pp.id == p.id

          merge_in(p.id, pp.id)
        end

        begin
          p.hydrate_player_info
        rescue
          puts 'retry...'
          retry
        end
      end
    end
  end

  def self.find_doublons
    Player.order(elo: :desc).first(300).each do |p|

      Player.where('name like ?', "%#{p.name}%").each do |other_p|
        next if other_p.id == p.id

        puts "#{other_p.name} elo: #{other_p.elo} matches #{other_p.winning_matches.count} results #{other_p.results.count} best_win => #{other_p.best_win&.loser&.name} best_result => #{other_p.results.order(rank: :asc).first&.rank} @ #{other_p.results.order(rank: :asc).first&.tournament&.name}"
        puts "#{p.name} <= #{other_p.name}"

        input = gets
        self.merge_in(p.id, other_p.id) if input.strip == 'yes'
        other_p.destroy if input.strip == 'destroy'
        break if input.strip == 'skip' || input.strip == 's'
      end
    end
  end

  def self.merge_in(id_in, id_to_destroy)
    Player.find(id_to_destroy).winning_matches.update_all(winner_player_id: id_in)
    Player.find(id_to_destroy).losing_matches.update_all(loser_player_id: id_in)
    Player.find(id_to_destroy).results.update_all(player_id: id_in)
    Player.find(id_to_destroy).destroy
  end

  def self.merge_in_array(id_in, arr)
    arr.each do |id_to_destroy|
      merge_in(id_in, id_to_destroy)
    end
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

  def elo_diffs
    elo_by_times.deep_pluck(:order, :elo, match: { tournament: :id }).group_by do |e|
      e[:match][:tournament]['id']
    end.each_with_object({}) do |(k, v), h|
      sorted = v&.sort_by { |key, _| key['order'] }
      h[k] = sorted&.last.try(:[], 'elo').to_i - sorted&.first.try(:[], 'elo').to_i
    end
  end

  def hydrate_player_info
    sleep(1)
    smashgg_user = query_smash_gg(User.user_query(smashgg_user_id))
    params = {
      prefix: smashgg_user.dig('data', 'user', 'player', 'prefix'),
      current_mpgr_ranking: smashgg_user.dig('data', 'user', 'player', 'rankings')&.reject do |r|
        r['title'] != 'MPGR: 2019 MPGR'
      end.try(:[], 0).try(:[], 'rank'),
      username: smashgg_user.dig('data', 'user', 'name'),
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

    update(params)
  end

  def self.hydrate_players_info
    players = Player.where('smashgg_user_id is not null and profile_picture_url is null and country is null').order(elo: :desc)

    bar = ProgressBar.new(players.count)

    without_logs do
      players.each do |player|
        bar.increment!
        begin
          player.hydrate_player_info
        rescue
          puts 'retry...'
          retry
        end
      end
    end
  end

end
