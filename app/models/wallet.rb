class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true  # could be a User
end
