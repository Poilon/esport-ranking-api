Characters::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Characters'
  type types[Characters::Type]

  argument :character, !types[Characters::Mutations::InputType]

  resolve ApplicationService.call(:character, :bulk_create)
end
