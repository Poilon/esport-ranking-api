class Game < ApplicationRecord

  has_many :characters
  has_many :tournaments
end
