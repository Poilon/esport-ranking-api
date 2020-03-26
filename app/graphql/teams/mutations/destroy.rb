Teams::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Team'
  type Teams::Type

  argument :id, !types.String

  resolve ApplicationService.call(:team, :destroy)
end
