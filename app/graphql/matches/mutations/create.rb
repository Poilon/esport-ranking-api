Matches::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Match'
  type Matches::Type

  argument :match, !Matches::Mutations::InputType

  resolve ApplicationService.call(:match, :create)
end
