PlayerCharacters::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'PlayerCharacterInputType'
  description 'Properties for updating a PlayerCharacter'

  argument :player_id, types.String
  argument :character_id, types.String
  argument :rank, types.Int

end
