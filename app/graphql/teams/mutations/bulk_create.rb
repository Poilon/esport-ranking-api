Teams::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Teams'
  type types[Teams::Type]

  argument :team, !types[Teams::Mutations::InputType]

  resolve ApplicationService.call(:team, :bulk_create)
end
