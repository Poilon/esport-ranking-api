QueryType = GraphQL::ObjectType.define do
  name 'Query'

  Graphql::Rails::Api::Config.query_resources.each do |resource|
    field resource.singularize do
      description "Returns a #{resource.classify}"
      type !"#{resource.camelize}::Type".constantize
      argument :id, !types.String
      resolve ApplicationService.call(resource, :show)
    end

    field resource.pluralize do
      description "Returns a #{resource.classify}"
      type !types[!"#{resource.camelize}::Type".constantize]
      argument :active, types.Boolean
      argument :page, types.Int
      argument :per_page, types.Int
      argument :filter, types.String
      argument :order_by, types.String
      resolve ApplicationService.call(resource, :index)
    end

  end

  field :countries, types[types.String] do
    resolve lambda { |_, _, _|
      ['Europe'] + ['United States'] + (Player.pluck(:country).uniq.compact.sort.reject { |e| e == 'United States' })
    }
  end
  field :states, types[types.String] do
    argument :countries, types.String
    resolve ->(_, args, _) { Player.where(country: args[:countries].split(',')).pluck(:state).uniq.compact.sort }
  end
  field :cities, types[types.String] do
    argument :countries, types.String
    argument :states, types.String
    resolve lambda { |_, args, _|
      if args[:states]
        Player.where(country: args[:countries].split(','), state: args[:states].split(',')).pluck(:city).uniq.compact.sort
      else
        Player.where(country: args[:countries].split(',')).pluck(:city).uniq.compact.sort
      end
    }
  end

  field :me, Users::Type do
    description 'Returns the current user'
    resolve ->(_, _, ctx) { ctx[:current_user] }
  end

end
