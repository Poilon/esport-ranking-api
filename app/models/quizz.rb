class Quizz < ApplicationRecord

  has_many :quizz_questions
  has_many :questions, through: :quizz_questions

  belongs_to :user, optional: true

  def self.generate_quizzs
    q = Question.create(name: "Who won #{tournament.name} ?")
    q.answers.create(name: 'Mang0')
    a = q.answers.create(name: 'billibopeep')
    q.answers.create(name: 'Poilon')
    q.answers.create(name: 'Vek')
    q.update(answer_id: a.id)
    quizz = Quizz.create
    quizz.questions << q
  end

end
