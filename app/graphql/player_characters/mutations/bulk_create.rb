PlayerCharacters::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some PlayerCharacters'
  type types[PlayerCharacters::Type]

  argument :player_character, !types[PlayerCharacters::Mutations::InputType]

  resolve ApplicationService.call(:player_character, :bulk_create)
end
