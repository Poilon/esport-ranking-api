Questions::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Questions'
  type types[Questions::Type]

  argument :question, !types[Questions::Mutations::InputType]

  resolve ApplicationService.call(:question, :bulk_update)
end
