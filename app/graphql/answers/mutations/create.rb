Answers::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Answer'
  type Answers::Type

  argument :answer, !Answers::Mutations::InputType

  resolve ApplicationService.call(:answer, :create)
end
