Users::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'UserInputType'
  description 'Properties for updating a User'
  argument :user_answer_ids, types[types.String]
  argument :encrypted_password, types.String
  argument :global_quizz_score, types.Int
  argument :quizz_ids, types[types.String]
  argument :websocket_connection_ids, types[types.String]

  argument :first_name, types.String
  argument :last_name, types.String
  argument :email, types.String

end
