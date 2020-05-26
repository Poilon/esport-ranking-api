Quizzs::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a Quizz'
  type Quizzs::Type

  argument :id, !types.String

  resolve ApplicationService.call(:quizz, :destroy)
end
