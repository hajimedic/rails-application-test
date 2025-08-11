# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 初期ユーザー作成
if defined?(User)
  user_id = ENV.fetch("user_id", "recruit_56522")
  password = ENV.fetch("user_password", "password")

  User.find_or_create_by!(user_id: user_id) do |u|
    u.password = password
  end
  puts "Seeded user: #{user_id}"
else
  puts "User model is not loaded; run migrations first."
end
