Players::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Players'
  type types[Players::Type]

  argument :player, !types[Players::Mutations::InputType]

  resolve ApplicationService.call(:player, :bulk_create)
end
