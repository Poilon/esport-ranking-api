Characters::Type = GraphQL::ObjectType.define do
  name 'Character'
  field :id, !types.String
  field :player_character_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :player_characters, types[PlayerCharacters::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :name, types.String
  field :slug, types.String
  field :game_id, types.String
  field :game, Games::Type
end
