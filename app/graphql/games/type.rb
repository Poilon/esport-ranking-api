Games::Type = GraphQL::ObjectType.define do
  name 'Game'
  field :id, !types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :smashgg_id, types.Int
  field :name, types.String
  field :slug, types.String
end
