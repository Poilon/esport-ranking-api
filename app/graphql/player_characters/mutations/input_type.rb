PlayerCharacters::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'PlayerCharacterInputType'
  description 'Properties for updating a PlayerCharacter'

  argument :blongs_to, types.String
  argument :character_id, types.String
  argument :rank, types.Int

end
