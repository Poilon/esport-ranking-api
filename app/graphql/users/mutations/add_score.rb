Users::Mutations::AddScore = GraphQL::Field.define do
    description 'Increse the score by the amount given'
    type types[Users::Type]
  
    argument :id, !types.String
    argument :score, !types.Int

    def resolve(id:, score:)
        u = User.find(id)
        uS = u.global_quizz_score
        uS += score 
        u.global_quizz_score = uS 
        u.save
    end
  end