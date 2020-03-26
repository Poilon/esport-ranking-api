PlayerCharacters::Type = GraphQL::ObjectType.define do
  name 'PlayerCharacter'
  field :id, !types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :player_id, types.String
  field :player, Players::Type
  field :character_id, types.String
  field :character, Characters::Type
  field :rank, types.Int
end
