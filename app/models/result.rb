class Result < ApplicationRecord

  belongs_to :tournament
  belongs_to :player
  default_scope { joins(:tournament).order('rank asc, tournaments.date desc') }

end
