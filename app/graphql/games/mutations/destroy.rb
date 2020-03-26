Games::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Game'
  type Games::Type

  argument :id, !types.String

  resolve ApplicationService.call(:game, :destroy)
end
