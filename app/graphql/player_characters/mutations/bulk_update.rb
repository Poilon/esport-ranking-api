PlayerCharacters::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some PlayerCharacters'
  type types[PlayerCharacters::Type]

  argument :player_character, !types[PlayerCharacters::Mutations::InputType]

  resolve ApplicationService.call(:player_character, :bulk_update)
end
