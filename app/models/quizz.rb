class Quizz < ApplicationRecord

  has_many :quizz_questions
  has_many :questions, through: :quizz_questions

  belongs_to :user, optional: true

  def self.generate_quizz(tournament)
    q = Question.create(name: "Who won #{tournament.name} ?")
    q.answers.create(name: 'Mang0')
    a = q.answers.create(name: 'billibopeep')
    q.answers.create(name: 'Poilon')
    q.answers.create(name: 'Vek')
    q.update(answer_id: a.id)
    quizz = Quizz.create
    quizz.questions << q
  end

  def self.generate_one_quizz
    i = 0
    quizz = Quizz.create
    tournaments = Tournament.joins(:results).where('results.id IS NOT NULL').order('RANDOM()').limit(10)
    tournaments.each do |tournament|
      q = Question.create(name: "Who won #{tournament.name} ?")
      a = q.answers.create(name: "#{tournament.results[0].player.name}")
      q.answers.create(name: "#{tournament.results[1].player.name}")
      q.answers.create(name: "#{tournament.results[2].player.name}")
      q.answers.create(name: "#{tournament.results[3].player.name}")
      q.update(answer_id: a.id)
      quizz.questions << q
    end
  end

end
