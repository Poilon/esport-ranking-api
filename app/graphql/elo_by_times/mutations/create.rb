EloByTimes::Mutations::Create = GraphQL::Field.define do
  description 'Creates a EloByTime'
  type EloByTimes::Type

  argument :elo_by_time, !EloByTimes::Mutations::InputType

  resolve ApplicationService.call(:elo_by_time, :create)
end
