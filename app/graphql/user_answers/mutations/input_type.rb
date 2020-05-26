UserAnswers::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'UserAnswerInputType'
  description 'Properties for updating a UserAnswer'

  argument :user_id, types.String
  argument :answer_id, types.String
  argument :right_answer, types.Boolean
  argument :time, types.Int

end
