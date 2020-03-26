Results::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Results'
  type types[Results::Type]

  argument :result, !types[Results::Mutations::InputType]

  resolve ApplicationService.call(:result, :bulk_update)
end
