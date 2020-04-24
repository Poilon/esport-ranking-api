class Result < ApplicationRecord

  belongs_to :tournament
  belongs_to :player
  default_scope { joins(:tournament).order('tournaments.date desc') }

end
