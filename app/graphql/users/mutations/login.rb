Users::Mutations::Login = GraphQL::Field.define do
  description 'Login a User'
  type types.String

  argument :email, !types.String
  argument :password, !types.String

  resolve ApplicationService.call(:user, :login)
end
