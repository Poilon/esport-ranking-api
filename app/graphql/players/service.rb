module Players
  class Service < ApplicationService

    def index
      collection =
        if params[:active]
          Player.joins(:elo_by_times).where('elo_by_times.date > ?', 1.year.ago).distinct
        else
          Player.all
        end

      if params[:characters]
        collection = collection.joins(:characters).where(characters: { name: params[:characters].split(',') }).distinct
      end

      Graphql::HydrateQuery.new(
        collection,
        @context,
        order_by: params[:order_by],
        filter: params[:filter],
        per_page: params[:per_page],
        page: params[:page],
        user: user
      ).run.compact
    end

    def update
      if !args[:security_token] || args[:security_token].size < 31 || args[:security_token] != ENV['SECURITY_TOKEN']
        graphql_error('Authentication Failed')
      else
        super
      end
    end

  end
end
