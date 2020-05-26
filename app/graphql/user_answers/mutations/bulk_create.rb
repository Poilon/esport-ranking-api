UserAnswers::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some UserAnswers'
  type types[UserAnswers::Type]

  argument :user_answer, !types[UserAnswers::Mutations::InputType]

  resolve ApplicationService.call(:user_answer, :bulk_create)
end
