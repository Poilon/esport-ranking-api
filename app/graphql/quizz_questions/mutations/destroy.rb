QuizzQuestions::Mutations::Destroy = GraphQL::Field.define do
  description 'Destroys a QuizzQuestion'
  type QuizzQuestions::Type

  argument :id, !types.String

  resolve ApplicationService.call(:quizz_question, :destroy)
end
