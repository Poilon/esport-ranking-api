UserAnswers::Type = GraphQL::ObjectType.define do
  name 'UserAnswer'
  field :id, !types.String
  field :created_at, types.String
  field :updated_at, types.String
  field :user_id, types.String
  field :user, Users::Type
  field :answer_id, types.String
  field :answer, Answers::Type
  field :right_answer, types.Boolean
  field :time, types.Int
end
