Games::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Games'
  type types[Games::Type]

  argument :game, !types[Games::Mutations::InputType]

  resolve ApplicationService.call(:game, :bulk_create)
end
