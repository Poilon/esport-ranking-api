EloByTimes::Type = GraphQL::ObjectType.define do
  name 'EloByTime'
  field :id, !types.String
  field :match_id, types.String
  field :match, Matches::Type
  field :created_at, types.String
  field :updated_at, types.String
  field :date, types.String
  field :player_id, types.String
  field :player, Players::Type
  field :elo, types.Int
end
