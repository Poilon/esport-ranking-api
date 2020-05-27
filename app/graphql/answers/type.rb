Answers::Type = GraphQL::ObjectType.define do
  name 'Answer'
  field :id, !types.String
  field :user_answer_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :user_answers, types[UserAnswers::Type]
  field :question_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :questions, types[Questions::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :name, types.String
  field :question_id, types.String
  field :question, Questions::Type
end
