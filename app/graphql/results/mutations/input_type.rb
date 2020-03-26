Results::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'ResultInputType'
  description 'Properties for updating a Result'

  argument :player_id, types.String
  argument :tournament_id, types.String
  argument :rank, types.Int

end
