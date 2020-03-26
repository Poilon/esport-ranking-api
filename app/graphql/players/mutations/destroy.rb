Players::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Player'
  type Players::Type

  argument :id, !types.String

  resolve ApplicationService.call(:player, :destroy)
end
