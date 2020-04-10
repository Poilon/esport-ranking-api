EloByTimes::Mutations::Update = GraphQL::Field.define do
  description 'Updates a EloByTime'
  type EloByTimes::Type

  argument :id, types.String
  argument :elo_by_time, !EloByTimes::Mutations::InputType

  resolve ApplicationService.call(:elo_by_time, :update)
end
