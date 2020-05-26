Answers::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'AnswerInputType'
  description 'Properties for updating a Answer'
  argument :user_answer_ids, types[types.String]

  argument :name, types.String
  argument :question_id, types.String

end
