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

  def self.generate_quizzs
    i = 0
    starts = Time.now.to_i
    bar = ProgressBar.new(100)
    without_logs do
      until i == 100 do
        bar.increment!
        i += 1
        quizz = Quizz.create
        questions_count = 0
        quizz.update(starts_at: starts)
        starts += 60
        tournaments = Tournament.joins(:results).order('RANDOM()').limit(1000)
        tournaments.each do |tournament|
          next if tournament.results.count < 4
          break if questions_count > 10

          questions_count += 1
          q = Question.create(name: "Who won #{tournament.name} ?")
          a = q.answers.create(name: "#{tournament.results.find_by(rank: 1)&.player&.name}")
          q.answers.create(name: "#{tournament.results.find_by(rank: 2)&.player&.name}")
          q.answers.create(name: "#{tournament.results.find_by(rank: 3)&.player&.name}")
          q.answers.create(name: "#{tournament.results.find_by(rank: 4)&.player&.name}")
          q.update(answer_id: a.id)
          quizz.questions << q
        end
      end
    end
  end

  def self.deleting
    Quizz.delete_all
    QuizzQuestion.delete_all
    Answer.delete_all
    Question.delete_all
    UserAnswer.delete_all
  end

end
