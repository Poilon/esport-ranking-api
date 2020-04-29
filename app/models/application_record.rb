class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true

  def self.visible_for(*)
    all
  end

  def self.writable_by(*)
    all
  end

  def self.broadcast_queries
    WebsocketConnection.all.each do |wsc|
      wsc.subscribed_queries.each do |sq|
        result = EsportRankingApiSchema.execute(sq.query, context: { current_user: wsc.user })
        hex = Digest::SHA1.hexdigest(result.to_s)
        next if sq.result_hash == hex

        sq.update_attributes(result_hash: hex)
        SubscriptionsChannel.broadcast_to(wsc, query: sq.query, result: result.to_s)
      end
    end
  end

  def self.without_logs
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    yield
    ActiveRecord::Base.logger = old_logger
  end

  def self.query_smash_gg(query)
    HTTParty.post(
      'https://api.smash.gg/gql/alpha',
      body: { query: query },
      headers: { Authorization: "Bearer #{ENV['SMASHGG_API_TOKEN']}" }
    )
  end

  def query_smash_gg(query)
    HTTParty.post(
      'https://api.smash.gg/gql/alpha',
      body: { query: query },
      headers: { Authorization: "Bearer #{ENV['SMASHGG_API_TOKEN']}" }
    )
  end

  def without_logs
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    yield
    ActiveRecord::Base.logger = old_logger
  end

end
