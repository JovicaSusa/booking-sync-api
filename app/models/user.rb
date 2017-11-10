class User < ApplicationRecord
  # encrypt password
  has_secure_password

  validates_presence_of :username, :password_digest
end
