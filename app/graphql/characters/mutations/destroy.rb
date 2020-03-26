Characters::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Character'
  type Characters::Type

  argument :id, !types.String

  resolve ApplicationService.call(:character, :destroy)
end
