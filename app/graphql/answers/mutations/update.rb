Answers::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Answer'
  type Answers::Type

  argument :id, types.String
  argument :answer, !Answers::Mutations::InputType

  resolve ApplicationService.call(:answer, :update)
end
