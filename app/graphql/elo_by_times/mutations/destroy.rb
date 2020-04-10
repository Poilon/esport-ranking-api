EloByTimes::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a EloByTime'
  type EloByTimes::Type

  argument :id, !types.String

  resolve ApplicationService.call(:elo_by_time, :destroy)
end
