module Players
  class Service < ApplicationService

    def index
      collection =
        if params[:active]
          Player.joins(:elo_by_times).where('elo_by_times.date > ?', 1.year.ago).distinct
        else
          Player.all
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

  end
end
