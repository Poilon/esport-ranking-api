PlayerCharacters::Mutations::Create = GraphQL::Field.define do
  description 'Creates a PlayerCharacter'
  type PlayerCharacters::Type

  argument :player_character, !PlayerCharacters::Mutations::InputType

  resolve ApplicationService.call(:player_character, :create)
end
