class User < ApplicationRecord

  has_one :wallet, as: :owner
end
