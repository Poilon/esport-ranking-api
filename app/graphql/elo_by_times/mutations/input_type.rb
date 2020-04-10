EloByTimes::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'EloByTimeInputType'
  description 'Properties for updating a EloByTime'
  argument :match_id, types.String

  argument :date, types.String
  argument :player_id, types.String
  argument :elo, types.Int

end
