Users::Type = GraphQL::ObjectType.define do
  name 'User'
  field :id, !types.String
  field :name, types.String
  field :name, types.String
  field :user_answer_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :user_answers, types[UserAnswers::Type]
  field :encrypted_password, types.String
  field :global_quizz_score, types.Int
  field :quizz_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :quizzs, types[Quizzs::Type]
  field :websocket_connection_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :websocket_connections, types[WebsocketConnections::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :first_name, types.String
  field :last_name, types.String
  field :email, types.String
end
