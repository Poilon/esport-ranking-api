Tournaments::Type = GraphQL::ObjectType.define do
  name 'Tournament'
  field :id, !types.String
  field :match_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :matches, types[Matches::Type]
  field :online, types.Boolean
  field :result_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :results, types[Results::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :date, types.String
  field :smashgg_id, types.Int
  field :smashgg_link_url, types.String
  field :name, types.String
  field :weight, types.Int
  field :game_id, types.String
  field :game, Games::Type
end
