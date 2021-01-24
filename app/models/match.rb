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
    items = Tournament.joins(:matches).where(matches: { played: false }).order('date asc').distinct
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
      Tournament.import_matches_of_tournament_from_smashgg(smashgg_event_id)
      Tournament.find_by(smashgg_id: smashgg_event_id)&.update(imported_matches: true)
    end

    ActiveRecord::Base.logger = old_logger
  end

  def self.run_score
    score_by_rank = { 25 => 5, 17 => 10, 13 => 15, 9 => 20, 7 => 30, 5 => 40, 4 => 50, 3 => 65, 2 => 80, 1 => 100 }

    Player.all.each do |p|
      s = 0
      p.results.map { |r| s += score_by_rank[r.rank].to_i }
      p.update(score: s)
    end
  end

end
