Matches::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Match'
  type Matches::Type

  argument :id, types.String
  argument :match, !Matches::Mutations::InputType

  resolve ApplicationService.call(:match, :update)
end
