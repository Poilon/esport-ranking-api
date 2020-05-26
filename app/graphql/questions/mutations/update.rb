Questions::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Question'
  type Questions::Type

  argument :id, types.String
  argument :question, !Questions::Mutations::InputType

  resolve ApplicationService.call(:question, :update)
end
