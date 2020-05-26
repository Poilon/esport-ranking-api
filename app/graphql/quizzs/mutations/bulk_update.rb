Quizzs::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Quizzs'
  type types[Quizzs::Type]

  argument :quizz, !types[Quizzs::Mutations::InputType]

  resolve ApplicationService.call(:quizz, :bulk_update)
end
