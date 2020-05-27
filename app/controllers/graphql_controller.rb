class GraphqlController < ApplicationController

  # GraphQL endpoint
  def execute
    result = EsportRankingApiSchema.execute(
      params[:query],
      variables: ensure_hash(params[:variables]),
      context: { current_user: authenticated_user },
      operation_name: params[:operationName]
    )
    ApplicationRecord.broadcast_queries
    render json: result
  end

  private

  def authenticated_user
    puts "############################## #{request.env['HTTP_SESSIONID']}"
    return if request.env['HTTP_SESSIONID'].blank? || request.env['HTTP_SESSIONID'] == 'null'

    crypt = ActiveSupport::MessageEncryptor.new(Base64.decode64(ENV['SECRET_AUTH_KEY']))
    User.find_by(id: crypt.decrypt_and_verify(request.env['HTTP_SESSIONID']))
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      ambiguous_param.present? ? ensure_hash(JSON.parse(ambiguous_param)) : {}
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, 'Unexpected parameter: ' + ambiguous_param
    end
  end

end
