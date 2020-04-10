Matches::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'MatchInputType'
  description 'Properties for updating a Match'
  argument :elo_by_time_ids, types[types.String]
  argument :is_loser_bracket, types.Boolean
  argument :full_round_text, types.String
  argument :display_score, types.String
  argument :played, types.Boolean
  argument :smashgg_id, types.Int
  argument :vod_url, types.String

  argument :winner_player_id, types.String
  argument :loser_player_id, types.String
  argument :tournament_id, types.String

end
