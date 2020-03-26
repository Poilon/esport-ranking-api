Teams::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Teams'
  type types[Teams::Type]

  argument :team, !types[Teams::Mutations::InputType]

  resolve ApplicationService.call(:team, :bulk_update)
end
