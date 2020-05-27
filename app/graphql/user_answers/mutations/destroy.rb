UserAnswers::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a UserAnswer'
  type UserAnswers::Type

  argument :id, !types.String

  resolve ApplicationService.call(:user_answer, :destroy)
end
