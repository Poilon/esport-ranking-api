Games::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'GameInputType'
  description 'Properties for updating a Game'

  argument :smashgg_id, types.Int
  argument :name, types.String
  argument :slug, types.String

end
