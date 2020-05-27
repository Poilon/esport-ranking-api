class Question < ApplicationRecord

  belongs_to :answer, optional: true
  has_many :answers
  has_many :quizz_questions
  has_many :quizzs, through: :quizz_questions

end
