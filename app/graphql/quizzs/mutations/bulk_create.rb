Quizzs::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Quizzs'
  type types[Quizzs::Type]

  argument :quizz, !types[Quizzs::Mutations::InputType]

  resolve ApplicationService.call(:quizz, :bulk_create)
end
