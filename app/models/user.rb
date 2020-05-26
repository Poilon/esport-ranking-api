class User < ApplicationRecord

  has_many :user_answers
  has_many :quizzs
  has_many :websocket_connections
end
