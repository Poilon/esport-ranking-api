Teams::Mutations::Create = GraphQL::Field.define do
  description 'Creates a Team'
  type Teams::Type

  argument :team, !Teams::Mutations::InputType

  resolve ApplicationService.call(:team, :create)
end
