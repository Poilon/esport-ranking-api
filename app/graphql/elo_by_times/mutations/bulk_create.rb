EloByTimes::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some EloByTimes'
  type types[EloByTimes::Type]

  argument :elo_by_time, !types[EloByTimes::Mutations::InputType]

  resolve ApplicationService.call(:elo_by_time, :bulk_create)
end
