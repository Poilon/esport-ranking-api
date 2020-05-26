Answers::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Answers'
  type types[Answers::Type]

  argument :answer, !types[Answers::Mutations::InputType]

  resolve ApplicationService.call(:answer, :bulk_update)
end
