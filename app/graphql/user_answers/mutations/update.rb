UserAnswers::Mutations::Update = GraphQL::Field.define do
  description 'Updates a UserAnswer'
  type UserAnswers::Type

  argument :id, types.String
  argument :user_answer, !UserAnswers::Mutations::InputType

  resolve ApplicationService.call(:user_answer, :update)
end
