Teams::Type = GraphQL::ObjectType.define do
  name 'Team'
  field :id, !types.String
  field :player_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :players, types[Players::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :name, types.String
  field :prefix, types.String
  field :slug, types.String
end
