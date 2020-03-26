Characters::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Characters'
  type types[Characters::Type]

  argument :character, !types[Characters::Mutations::InputType]

  resolve ApplicationService.call(:character, :bulk_update)
end
