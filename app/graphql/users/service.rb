module Users
  class Service < ApplicationService

    def login
      user = User.find_by(email: params[:email])
      return graphql_error('Email not found') if user.blank?

      if user.password == params[:password]
        crypt = ActiveSupport::MessageEncryptor.new(Base64.decode64(ENV['SECRET_AUTH_KEY']))
        crypt.encrypt_and_sign(user.id)
      else
        graphql_error('Wrong password')
      end
    end

  end
end
