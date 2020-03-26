Players::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Player'
  type Players::Type

  argument :player, !Players::Mutations::InputType

  resolve ApplicationService.call(:player, :create)
end
