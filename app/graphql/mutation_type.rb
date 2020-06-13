MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  Graphql::Rails::Api::Config.mutation_resources.each do |methd, resources|
    resources.each do |resource|
      field(
        "#{methd}_#{resource.singularize}".to_sym,
        "#{resource.camelize}::Mutations::#{methd.camelize}".constantize
      )
    end
  end

  field :update_player, Players::Mutations::Update
  field :add_score, Users::Mutations::AddScore
end
