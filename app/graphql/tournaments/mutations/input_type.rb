Tournaments::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'TournamentInputType'
  description 'Properties for updating a Tournament'
  argument :processed, types.Boolean
  argument :match_ids, types[types.String]
  argument :online, types.Boolean
  argument :result_ids, types[types.String]

  argument :date, types.String
  argument :smashgg_id, types.Int
  argument :smashgg_link_url, types.String
  argument :name, types.String
  argument :weight, types.Int
  argument :game_id, types.String

end
