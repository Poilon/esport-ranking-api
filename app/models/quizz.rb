class Quizz < ApplicationRecord

  has_many :quizz_questions
  belongs_to :user
end
