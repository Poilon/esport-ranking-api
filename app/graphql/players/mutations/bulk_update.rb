Players::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Players'
  type types[Players::Type]

  argument :player, !types[Players::Mutations::InputType]

  resolve ApplicationService.call(:player, :bulk_update)
end
