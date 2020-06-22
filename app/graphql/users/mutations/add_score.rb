Users::Mutations::AddScore = GraphQL::Field.define do
  description 'Increse the score by the amount given'
  type Users::Type

  argument :id, !types.String
  argument :score, !types.Int

  resolve ApplicationService.call(:user, :add_score)
end
