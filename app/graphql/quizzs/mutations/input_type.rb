Quizzs::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'QuizzInputType'
  description 'Properties for updating a Quizz'
  argument :starts_at, types.Int
  argument :quizz_question_ids, types[types.String]

  argument :user_id, types.String

end
