Matches::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some Matches'
  type types[Matches::Type]

  argument :match, !types[Matches::Mutations::InputType]

  resolve ApplicationService.call(:match, :bulk_update)
end
