Games::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Game'
  type Games::Type

  argument :id, types.String
  argument :game, !Games::Mutations::InputType

  resolve ApplicationService.call(:game, :update)
end
