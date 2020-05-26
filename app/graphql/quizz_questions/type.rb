QuizzQuestions::Type = GraphQL::ObjectType.define do
  name 'QuizzQuestion'
  field :id, !types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :quizz_id, types.String
  field :quizz, Quizzs::Type
  field :question_id, types.String
  field :question, Questions::Type
end
