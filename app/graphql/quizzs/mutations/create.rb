Quizzs::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Quizz'
  type Quizzs::Type

  argument :quizz, !Quizzs::Mutations::InputType

  resolve ApplicationService.call(:quizz, :create)
end
