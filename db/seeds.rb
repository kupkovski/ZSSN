# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

(1..50).each do |n|
  data = {
    name: Faker::Name.name,
    birthdate: Faker::Date.between(from: Date.current - 70.years, to: Date.current - 20.years),
    gender: %w[male female].sample,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    infected: false
  }

  User.create!(data)
  print "."
  puts "Done!"
end
