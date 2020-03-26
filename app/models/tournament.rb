class Tournament < ApplicationRecord

  has_many :results
  belongs_to :game
end
