# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Wallet.destroy_all
User.destroy_all

tom = User.create(email: 'tom@money.com')
dick = User.create(email: 'dick@money.com')
sally = User.create(email: 'sally@money.com')

User.all.each do |user|
  Wallet.create(user:, balance: [101,1234, 9999].sample)
end
