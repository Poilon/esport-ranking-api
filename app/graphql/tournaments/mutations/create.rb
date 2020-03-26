Tournaments::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Tournament'
  type Tournaments::Type

  argument :tournament, !Tournaments::Mutations::InputType

  resolve ApplicationService.call(:tournament, :create)
end
