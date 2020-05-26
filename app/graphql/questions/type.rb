Questions::Type = GraphQL::ObjectType.define do
  name 'Question'
  field :id, !types.String
  field :answer_id, types.String
  field :answer, Answers::Type
  field :answer_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :answers, types[Answers::Type]
  field :quizz_question_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :quizz_questions, types[QuizzQuestions::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :name, types.String
end
