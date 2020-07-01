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
      # 480 quizzs (1 quizz per 3 min, 20 quizzs per hour, 480 quizzs per day)
      until i == 20 do
        bar.increment!
        i += 1
        quizz = Quizz.create
        questions_count = 0
        quizz.update(starts_at: starts)
        starts += 180
        tournaments = Tournament.joins(:results).group('tournaments.id').having('count(tournaments.id) > 100').order('RANDOM()').limit(1000)
        tournaments.each do |tournament|
          break if questions_count >= 5

          questions_count += 1
          date = tournament.date.strftime("%d/%m/%Y")
          q = Question.create(name: "Who won #{tournament.name} (#{date}) ?")
          a = q.answers.create(name: "#{tournament.results.find_by(rank: 1)&.player&.name}")
          q.answers.create(name: "#{tournament.results.find_by(rank: 2)&.player&.name}")
          q.answers.create(name: "#{tournament.results.find_by(rank: 3)&.player&.name}")
          q.answers.create(name: "#{tournament.results.find_by(rank: 4)&.player&.name}")
          q.update(answer_id: a.id)
          quizz.questions << q
        end

        # who is 1st of x

        # filtering countries that have less than 4 players
        firstListCountries = ['United States'] + (Player.pluck(:country).uniq.compact.sort.reject { |e| e == 'United States' })
        countries = Array.new
        firstListCountries.each do |c|
          numberOfPlayers = Player.where(country: c).count()
          if (numberOfPlayers >= 4)
            countries.push(c)
          end
        end

        countries_shuffled = countries.shuffle 
        countries_shuffled.each do |country|
          break if questions_count >= 10
          questions_count += 1

          p = Player.where(country: country).order(elo: :desc).limit(4)
          q = Question.create(name: "Who is currenly ranked #1 in #{country}?")
          a = q.answers.create(name: "#{p[0].name}")
          q.answers.create(name: "#{p[1].name}")
          q.answers.create(name: "#{p[2].name}")
          q.answers.create(name: "#{p[3].name}")
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
