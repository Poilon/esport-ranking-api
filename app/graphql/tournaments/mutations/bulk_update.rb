Tournaments::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Tournaments'
  type types[Tournaments::Type]

  argument :tournament, !types[Tournaments::Mutations::InputType]

  resolve ApplicationService.call(:tournament, :bulk_update)
end
