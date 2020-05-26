QuizzQuestions::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'QuizzQuestionInputType'
  description 'Properties for updating a QuizzQuestion'

  argument :quizz_id, types.String
  argument :question_id, types.String

end
