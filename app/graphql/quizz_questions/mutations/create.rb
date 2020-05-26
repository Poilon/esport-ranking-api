QuizzQuestions::Mutations::Create = GraphQL::Field.define do
  description 'Creates a QuizzQuestion'
  type QuizzQuestions::Type

  argument :quizz_question, !QuizzQuestions::Mutations::InputType

  resolve ApplicationService.call(:quizz_question, :create)
end
