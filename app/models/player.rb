class Player < ApplicationRecord

  has_many :player_characters
  has_many :characters, through: :player_characters
  has_many :results
  has_many :player_teams
  has_many :teams, through: :player_teams

  def self.compute
    all.each do |p|
      p.results.each do |r|
        weight = r.tournament.weight
        rank = r.rank

        p.score ||= 1000
        p.score += (weight.to_f * 1000 * (1 / rank.to_f)) / p.results.count.to_f
      end
      p.save

    end
  end

end
