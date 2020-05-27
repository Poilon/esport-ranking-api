module Players
  class Service < ApplicationService

    def index
      super(filtered_collection)
    end

    def paginated_index
      super(filtered_collection)
    end

    def update
      if !args[:security_token] || args[:security_token].size < 31 || args[:security_token] != ENV['SECURITY_TOKEN']
        graphql_error('Authentication Failed')
      else
        super
      end
    end

    private

    def filtered_collection
      collection =
        if params[:active]
          Player.joins(:elo_by_times).where('elo_by_times.date > ?', 1.year.ago).distinct
        else
          Player.all
        end

      if params[:characters]
        collection = collection.joins(:characters).where(characters: { name: params[:characters].split(',') }).distinct
      end
      collection
    end

  end
end
