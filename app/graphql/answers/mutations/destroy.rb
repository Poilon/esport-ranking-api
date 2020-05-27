Answers::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Answer'
  type Answers::Type

  argument :id, !types.String

  resolve ApplicationService.call(:answer, :destroy)
end
