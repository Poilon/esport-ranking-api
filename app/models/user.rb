class User < ApplicationRecord

  has_many :user_answers
  has_many :quizzs
  has_many :websocket_connections

  def password
    @password ||= BCrypt::Password.new(encrypted_password) if encrypted_password.present?
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.encrypted_password = @password
  end

end
