PlayerCharacters::Type = GraphQL::ObjectType.define do
  name 'PlayerCharacter'
  field :id, !types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :blongs_to, types.String
  field :character_id, types.String
  field :character, Characters::Type
  field :rank, types.Int
end
