Results::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Result'
  type Results::Type

  argument :id, types.String
  argument :result, !Results::Mutations::InputType

  resolve ApplicationService.call(:result, :update)
end
