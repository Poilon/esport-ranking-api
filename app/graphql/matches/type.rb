Matches::Type = GraphQL::ObjectType.define do
  name 'Match'
  field :id, !types.String
  field :round, types.Int
  field :elo_by_time_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :elo_by_times, types[EloByTimes::Type]
  field :is_loser_bracket, types.Boolean
  field :full_round_text, types.String
  field :display_score, types.String
  field :played, types.Boolean
  field :smashgg_id, types.Int
  field :vod_url, types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :winner_player_id, types.String
  field :loser_player_id, types.String

  field :winner, Players::Type
  field :loser, Players::Type
  field :tournament_id, types.String
  field :tournament, Tournaments::Type
end
