class User < ApplicationRecord
  has_one :wallet, as: :owner

  def authenticate(password)
    password_digest == Digest::SHA256.hexdigest(password)
  end
end
