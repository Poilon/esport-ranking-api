Characters::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'CharacterInputType'
  description 'Properties for updating a Character'
  argument :smashgg_id, types.Int
  argument :player_character_ids, types[types.String]

  argument :name, types.String
  argument :slug, types.String
  argument :game_id, types.String

end
