Games::Type = GraphQL::ObjectType.define do
  name 'Game'
  field :id, !types.String
  field :character_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :characters, types[Characters::Type]
  field :tournament_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :tournaments, types[Tournaments::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :smashgg_id, types.Int
  field :name, types.String
  field :slug, types.String
end
