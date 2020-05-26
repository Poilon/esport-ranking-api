class Quizz < ApplicationRecord

  has_many :quizz_questions
  has_many :questions, through: :quizz_questions

  belongs_to :user, optional: true

end
