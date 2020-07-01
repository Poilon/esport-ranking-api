Users::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'UserInputType'
  description 'Properties for updating a User'
  argument :name, types.String
  argument :name, types.String
  argument :first_name, types.String
  argument :last_name, types.String
  argument :password, types.String
  argument :email, types.String

end
