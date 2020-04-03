Matches::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Matches'
  type types[Matches::Type]

  argument :match, !types[Matches::Mutations::InputType]

  resolve ApplicationService.call(:match, :bulk_create)
end
