Players::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Player'
  type Players::Type

  argument :id, types.String
  argument :security_token, !types.String
  argument :player, !Players::Mutations::InputType

  resolve ApplicationService.call(:player, :update)
end
