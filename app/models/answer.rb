class Answer < ApplicationRecord

  has_many :user_answers
  has_many :questions
  belongs_to :question
end
