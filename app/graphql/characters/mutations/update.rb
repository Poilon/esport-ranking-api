Characters::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Character'
  type Characters::Type

  argument :id, types.String
  argument :character, !Characters::Mutations::InputType

  resolve ApplicationService.call(:character, :update)
end
