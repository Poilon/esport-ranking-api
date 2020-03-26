Tournaments::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Tournament'
  type Tournaments::Type

  argument :id, types.String
  argument :tournament, !Tournaments::Mutations::InputType

  resolve ApplicationService.call(:tournament, :update)
end
