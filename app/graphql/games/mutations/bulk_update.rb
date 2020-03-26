Games::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Games'
  type types[Games::Type]

  argument :game, !types[Games::Mutations::InputType]

  resolve ApplicationService.call(:game, :bulk_update)
end
