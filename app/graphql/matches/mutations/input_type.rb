Matches::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'MatchInputType'
  description 'Properties for updating a Match'
  argument :smashgg_id, types.Int
  argument :vod_url, types.String

  argument :winner_player_id, types.String
  argument :loser_player_id, types.String
  argument :tournament_id, types.String

end
