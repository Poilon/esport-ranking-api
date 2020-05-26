Questions::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'QuestionInputType'
  description 'Properties for updating a Question'
  argument :answer_id, types.String
  argument :answer_ids, types[types.String]
  argument :quizz_question_ids, types[types.String]

  argument :name, types.String

end
