QuizzQuestions::Mutations::BulkUpdate = GraphQL::Field.define do
  description 'Updates some QuizzQuestions'
  type types[QuizzQuestions::Type]

  argument :quizz_question, !types[QuizzQuestions::Mutations::InputType]

  resolve ApplicationService.call(:quizz_question, :bulk_update)
end
