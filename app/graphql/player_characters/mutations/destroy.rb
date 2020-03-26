PlayerCharacters::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a PlayerCharacter'
  type PlayerCharacters::Type

  argument :id, !types.String

  resolve ApplicationService.call(:player_character, :destroy)
end
