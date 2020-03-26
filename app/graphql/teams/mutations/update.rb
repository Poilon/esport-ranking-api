Teams::Mutations::Update = GraphQL::Field.define do
  description 'Updates a Team'
  type Teams::Type

  argument :id, types.String
  argument :team, !Teams::Mutations::InputType

  resolve ApplicationService.call(:team, :update)
end
