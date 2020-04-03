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

  def compute
    update(score: 1000)
    results.each do |r|
      self.score += (r.tournament.weight.to_f / r.rank.to_f)
      save
    end
  end

end
