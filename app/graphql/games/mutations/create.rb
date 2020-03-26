Games::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Game'
  type Games::Type

  argument :game, !Games::Mutations::InputType

  resolve ApplicationService.call(:game, :create)
end
