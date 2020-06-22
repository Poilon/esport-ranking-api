Users::Mutations::AddScore = GraphQL::Field.define do
    description 'Increse the score by the amount given'
    type types[Users::Type]
  
    argument :id, !types.String
    argument :score, !types.Int

    def resolve(id:, score:)
        u = User.find(id)
        u.global_quizz_score += score
        u.save
    end
  end