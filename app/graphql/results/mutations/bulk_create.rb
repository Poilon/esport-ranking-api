Results::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Results'
  type types[Results::Type]

  argument :result, !types[Results::Mutations::InputType]

  resolve ApplicationService.call(:result, :bulk_create)
end
