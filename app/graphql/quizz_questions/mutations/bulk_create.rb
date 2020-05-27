QuizzQuestions::Mutations::BulkCreate = GraphQL::Field.define do
  description 'creates some QuizzQuestions'
  type types[QuizzQuestions::Type]

  argument :quizz_question, !types[QuizzQuestions::Mutations::InputType]

  resolve ApplicationService.call(:quizz_question, :bulk_create)
end
