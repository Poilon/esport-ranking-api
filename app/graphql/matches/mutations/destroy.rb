Matches::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Match'
  type Matches::Type

  argument :id, !types.String

  resolve ApplicationService.call(:match, :destroy)
end
