class QuizzQuestion < ApplicationRecord

  belongs_to :question
  belongs_to :quizz
end
