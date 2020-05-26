class Question < ApplicationRecord

  belongs_to :answer
  has_many :answers
  has_many :quizz_questions
end
