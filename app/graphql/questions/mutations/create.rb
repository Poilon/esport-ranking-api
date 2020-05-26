Questions::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Question'
  type Questions::Type

  argument :question, !Questions::Mutations::InputType

  resolve ApplicationService.call(:question, :create)
end
