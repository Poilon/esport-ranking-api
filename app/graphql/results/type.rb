Results::Type = GraphQL::ObjectType.define do
  name 'Result'
  field :id, !types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :player_id, types.String
  field :player, Players::Type
  field :tournament_id, types.String
  field :tournament, Tournaments::Type
  field :rank, types.Int
end
