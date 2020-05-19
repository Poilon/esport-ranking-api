QueryType = GraphQL::ObjectType.define do
  name 'Query'

  Graphql::Rails::Api::Config.query_resources.each do |resource|

    resource.pluralize.camelize.constantize.const_set(
      'PaginatedType',
      GraphQL::ObjectType.define do
        name "Paginated#{resource.classify}"

        field :total_count, !types.Int
        field :page, !types.Int
        field :per_page, !types.Int
        field :data, !types[!"#{resource.pluralize.camelize}::Type".constantize]

      end
    )

    field resource.singularize do
      description "Returns a #{resource.classify}"
      type !"#{resource.camelize}::Type".constantize
      argument :id, !types.String
      resolve ApplicationService.call(resource, :show)
    end

    field resource.pluralize do
      description "Returns a #{resource.classify}"
      type !types[!"#{resource.camelize}::Type".constantize]
      argument :page, types.Int
      argument :per_page, types.Int
      argument :filter, types.String
      argument :order_by, types.String
      resolve ApplicationService.call(resource, :index)
    end

    field "paginated_#{resource.pluralize}" do
      description "Return paginated #{resource.classify}"
      type "#{resource.camelize}::PaginatedType".constantize
      argument :filter, types.String
      argument :order_by, types.String
      argument :page, !types.Int
      argument :per_page, !types.Int
      resolve ApplicationService.call(resource, :paginated_index)
    end
  end

  field :players, types[Players::Type] do
    argument :active, types.Boolean
    argument :page, types.Int
    argument :per_page, types.Int
    argument :filter, types.String
    argument :order_by, types.String
    argument :characters, types.String
    resolve ApplicationService.call(:players, :index)
  end

  field :paginated_players, Players::PaginatedType do
    argument :active, types.Boolean
    argument :filter, types.String
    argument :order_by, types.String
    argument :page, !types.Int
    argument :per_page, !types.Int
    argument :characters, types.String
    resolve ApplicationService.call(:players, :paginated_index)
  end

  field :random_tournament, Tournaments::Type do
    resolve ->(_, _, _) { Tournament.order('RANDOM()').first }
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
