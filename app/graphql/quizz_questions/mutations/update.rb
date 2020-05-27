QuizzQuestions::Mutations::Update = GraphQL::Field.define do
  description 'Updates a QuizzQuestion'
  type QuizzQuestions::Type

  argument :id, types.String
  argument :quizz_question, !QuizzQuestions::Mutations::InputType

  resolve ApplicationService.call(:quizz_question, :update)
end
