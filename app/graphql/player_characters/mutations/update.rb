PlayerCharacters::Mutations::Update = GraphQL::Field.define do
  description 'Updates a PlayerCharacter'
  type PlayerCharacters::Type

  argument :id, types.String
  argument :player_character, !PlayerCharacters::Mutations::InputType

  resolve ApplicationService.call(:player_character, :update)
end
