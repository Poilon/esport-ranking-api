Answers::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Answers'
  type types[Answers::Type]

  argument :answer, !types[Answers::Mutations::InputType]

  resolve ApplicationService.call(:answer, :bulk_create)
end
