Questions::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some Questions'
  type types[Questions::Type]

  argument :question, !types[Questions::Mutations::InputType]

  resolve ApplicationService.call(:question, :bulk_create)
end
