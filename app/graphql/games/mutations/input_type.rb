Games::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'GameInputType'
  description 'Properties for updating a Game'
  argument :character_ids, types[types.String]
  argument :tournament_ids, types[types.String]

  argument :smashgg_id, types.Int
  argument :name, types.String
  argument :slug, types.String

end
