Questions::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Question'
  type Questions::Type

  argument :id, !types.String

  resolve ApplicationService.call(:question, :destroy)
end
