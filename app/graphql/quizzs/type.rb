Quizzs::Type = GraphQL::ObjectType.define do
  name 'Quizz'
  field :id, !types.String
  field :quizz_question_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :quizz_questions, types[QuizzQuestions::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :user_id, types.String
  field :user, Users::Type
end
