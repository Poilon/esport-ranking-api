Results::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Result'
  type Results::Type

  argument :id, !types.String

  resolve ApplicationService.call(:result, :destroy)
end
