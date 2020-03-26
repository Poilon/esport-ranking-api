class Character < ApplicationRecord

  has_many :player_characters
  belongs_to :game
end
