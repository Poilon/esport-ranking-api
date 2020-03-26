Tournaments::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Tournament'
  type Tournaments::Type

  argument :id, !types.String

  resolve ApplicationService.call(:tournament, :destroy)
end
