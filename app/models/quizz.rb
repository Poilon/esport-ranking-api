class Quizz < ApplicationRecord

  has_many :quizz_questions
  has_many :questions, through: :quizz_questions

  belongs_to :user, optional: true

  def self.generate_quizzs
    i = 0
    starts = Time.now.to_i
    bar = ProgressBar.new(100)
    without_logs do
      # 480 quizzs (1 quizz per 3 min, 20 quizzs per hour, 480 quizzs per day)
      until i == 30 do
        bar.increment!
        i += 1

        # Quizz creation
        quizz = Quizz.create
        questions_count = 0

        # Putting time of when the quizz is starting
        quizz.update(starts_at: starts)
        # One quizz every 3 min
        starts += 180

        # # # # # # # # # # # # # # # # # # # # # # # # 
        # # # # #                             # # # # # 
        # # # # # TOURNAMENT WINNER QUESTIONS # # # # #
        # # # # #                             # # # # # 
        # # # # # # # # # # # # # # # # # # # # # # # #

        tournaments = Tournament.joins(:results).group('tournaments.id').having('count(tournaments.id) > 100').order('RANDOM()').limit(1000)
        tournaments.each do |tournament|
          # 5 questions of tournament winner
          break if questions_count >= 5

          # ignore tournament if there is less than 4 results
          next if tournament.results.count < 4
          # ignore tournament if the name of the players are empty (sometimes tournaments are weirdly managed)
          next if tournament.results.find_by(rank: 2)&.player&.name == ""
          next if tournament.results.find_by(rank: 3)&.player&.name == ""
          next if tournament.results.find_by(rank: 4)&.player&.name == ""


          # Question & Answers creation
          questions_count += 1
          date = tournament.date.strftime("%d/%m/%Y")
          question_create("Who won \"#{tournament.name}\" (#{date})?", tournament.results.find_by(rank: 1)&.player&.name, tournament.results.find_by(rank: 2)&.player&.name, tournament.results.find_by(rank: 3)&.player&.name, tournament.results.find_by(rank: 4)&.player&.name, nil, quizz)
        end

        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        # # # # #                                                     # # # # # 
        # # # # # Who is the best in X country or state (for the USA) # # # # # 
        # # # # #                                                     # # # # # 
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

        # Filtering countries that have less than 4 players
        firstListCountries = ['United States'] + (Player.pluck(:country).uniq.compact.sort.reject { |e| e == 'United States' })
        countries = Array.new
        firstListCountries.each do |c|
          numberOfPlayers = Player.where(country: c).count()
          if (numberOfPlayers >= 4)
            countries.push(c)
          end
        end

        # Shuffling countries and picking one
        countries_shuffled = countries.shuffle 
        countries_shuffled.each do |country|
          # 4 questions of "who is the best in X" (9 = 4 + 5 of tournament winner)
          break if questions_count >= 9
          questions_count += 1

          # USA States letters into full name
          states = { "AK" => "Alaska", "AL" => "Alabama", "AR" => "Arkansas", "AS" => "American Samoa", "AZ" => "Arizona", "CA" => "California", "CO" => "Colorado", "CT" => "Connecticut", "DC" => "District of Columbia", "DE" => "Delaware", "FL" => "Florida", "GA" => "Georgia", "GU" => "Guam", "HI" => "Hawaii", "IA" => "Iowa", "ID" => "Idaho", "IL" => "Illinois", "IN" => "Indiana", "KS" => "Kansas", "KY" => "Kentucky", "LA" => "Louisiana", "MA" => "Massachusetts", "MD" => "Maryland", "ME" => "Maine", "MI" => "Michigan", "MN" => "Minnesota", "MO" => "Missouri", "MS" => "Mississippi", "MT" => "Montana", "NC" => "North Carolina", "ND" => "North Dakota", "NE" => "Nebraska", "NH" => "New Hampshire", "NJ" => "New Jersey", "NM" => "New Mexico", "NV" => "Nevada", "NY" => "New York", "OH" => "Ohio", "OK" => "Oklahoma", "OR" => "Oregon", "PA" => "Pennsylvania", "PR" => "Puerto Rico", "RI" => "Rhode Island", "SC" => "South Carolina", "SD" => "South Dakota", "TN" => "Tennessee", "TX" => "Texas", "UT" => "Utah", "VA" => "Virginia", "VI" => "Virgin Islands", "VT" => "Vermont", "WA" => "Washington", "WI" => "Wisconsin", "WV" => "West Virginia", "WY" => "Wyoming" }

          # If the country randomly picked is USA, we're looking at the best in a random USA state
          if country == 'United States'
            # States with at least 4 players ranked
            usaStates = Player.where(country: 'United States').pluck(:state).uniq.compact.sort
            usaStatesWithAtLeast4players = Array.new
            usaStates.each do |c|
              numberOfPlayersUSAstates = Player.where(country: 'United States', state: c).count()
              if (numberOfPlayersUSAstates >= 4)
                usaStatesWithAtLeast4players.push(c)
              end
            end

            # picking random state
            random = rand(usaStatesWithAtLeast4players.length)
            # picking the 4 best players
            playerUSAstate = Player.where(state: usaStatesWithAtLeast4players[random]).order(elo: :desc).limit(4)

            # creating question & answer
            question_create("Who is the best player in the state of #{states[usaStatesWithAtLeast4players[random]]} in the USA?", playerUSAstate[0].name, playerUSAstate[1].name, playerUSAstate[2].name, playerUSAstate[3].name, nil, quizz)
          else 
            # Question & answer if the randomly picked country isn't the USA
            p = Player.where(country: country).order(elo: :desc).limit(4)
            question_create("Who is currenly ranked #1 in #{country}?", p[0].name, p[1].name, p[2].name, p[3].name, nil, quizz)
          end
        end

        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        # # # # #                                                         # # # # # 
        # # # # # Frame data question (last question of the 10 questions) # # # # #
        # # # # #                                                         # # # # # 
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

        # characters
        characters = ["fox", "falco", "marth"]
        # picking one
        who = rand(3)
        # path of the json frame data file
        filePathChar = "../../../framedata/" + "marth" + ".json" #characters[who]
        file = File.read(File.expand_path(filePathChar, __FILE__))
        data_hash = JSON.parse(file)
        # moves possible
        moves = ["aerial", "smash", "tilt", "special", "jab", "dash", "grab", "dodge", "roll"]
        # picking one move
        randomMove = rand(moves.length)
        move = moves[randomMove]
        randomMoveNumber = rand(data_hash["attacks"][move].length)

        # name in lowercase
        moveName = data_hash["attacks"][move][randomMoveNumber]["description"].downcase!

        # frame answers
        frameTrue = data_hash["attacks"][move][randomMoveNumber]["total_frames"].to_i
        frameFalse1 = data_hash["attacks"][move][randomMoveNumber]["total_frames"].to_i + rand(1..4)
        frameFalse2 = data_hash["attacks"][move][randomMoveNumber]["total_frames"].to_i - rand(1..5)
        frameFalse3 = data_hash["attacks"][move][randomMoveNumber]["total_frames"].to_i + rand(5..8)

        # gif url of the move
        gifUrl = data_hash["attacks"][move][randomMoveNumber]["gif_url"]
        # creating the question
        question_create("How many frames does the #{moveName} of #{data_hash["charname"]} last?", frameTrue, frameFalse1, frameFalse2, frameFalse3, gifUrl, quizz)
      end
    end
  end

  # Question creation function
  def self.question_create(question, good_answer, answer1, answer2, answer3, gifUrl = nil, quizz)
    q = Question.create(name: question)
    a = q.answers.create(name: good_answer)
    q.answers.create(name: answer1)
    q.answers.create(name: answer2)
    q.answers.create(name: answer3)
    if (gifUrl != nil)
      q.update(gif_url: "#{gifUrl}")
    end
    q.update(answer_id: a.id)
    quizz.questions << q
    quizz
  end

  def self.deleting
    Quizz.delete_all
    QuizzQuestion.delete_all
    Answer.delete_all
    Question.delete_all
    UserAnswer.delete_all
  end

end
