Matches::Type = GraphQL::ObjectType.define do
  name 'Match'
  field :id, !types.String
  field :smashgg_id, types.Int
  field :vod_url, types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :winner_player_id, types.String
  field :loser_player_id, types.String
  field :tournament_id, types.String
  field :tournament, Tournaments::Type
end
