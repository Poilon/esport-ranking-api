UserAnswers::Mutations::Create = GraphQL::Field.define do
  description 'Creates a UserAnswer'
  type UserAnswers::Type

  argument :user_answer, !UserAnswers::Mutations::InputType

  resolve ApplicationService.call(:user_answer, :create)
end
