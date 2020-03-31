class Player < ApplicationRecord

  has_many :player_characters
  has_many :characters, through: :player_characters
  has_many :results
  has_many :player_teams
  has_many :teams, through: :player_teams

  def self.compute
    all.map(&:compute)
  end

  def compute
    self.score = 1000
    results.each do |r|
      weight = r.tournament.results.count
      rank = r.rank

      self.score ||= 1000
      self.score += (weight.to_f * 1000 * (1 / rank.to_f)) / results.count.to_f
      save
    end
  end

end
