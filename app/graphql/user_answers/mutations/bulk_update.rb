UserAnswers::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some UserAnswers'
  type types[UserAnswers::Type]

  argument :user_answer, !types[UserAnswers::Mutations::InputType]

  resolve ApplicationService.call(:user_answer, :bulk_update)
end
