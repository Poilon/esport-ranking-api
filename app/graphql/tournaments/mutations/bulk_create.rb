Tournaments::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Tournaments'
  type types[Tournaments::Type]

  argument :tournament, !types[Tournaments::Mutations::InputType]

  resolve ApplicationService.call(:tournament, :bulk_create)
end
