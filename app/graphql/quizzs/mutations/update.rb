Quizzs::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Quizz'
  type Quizzs::Type

  argument :id, types.String
  argument :quizz, !Quizzs::Mutations::InputType

  resolve ApplicationService.call(:quizz, :update)
end
