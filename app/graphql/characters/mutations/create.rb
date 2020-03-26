Characters::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Character'
  type Characters::Type

  argument :character, !Characters::Mutations::InputType

  resolve ApplicationService.call(:character, :create)
end
