Results::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Result'
  type Results::Type

  argument :result, !Results::Mutations::InputType

  resolve ApplicationService.call(:result, :create)
end
