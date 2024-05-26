require 'open-uri'
require 'faker'

puts "Cleaning database..."
Recommendation.destroy_all
User.destroy_all

puts "Creating user..."

User.create!(
  email: "test@test.com",
  user_name: "Bob",
  password: '123456',
)

# Seed data
10.times do |i|
  # Generate random name and description using Faker
  name = Faker::Restaurant.name
  description = Faker::Restaurant.description

  # Fetch a random image URL from Unsplash
  image_url = "https://source.unsplash.com/random/?restaurant"

  # Create a new recommendation record
  Recommendation.create!(
    name: name,
    user_id: User.first.id,
    description: description,
    visit_date: Date.today,
    address: Faker::Address.full_address,
    recommendation_type: rand(0..8), # Assuming you have 9 types from 0 to 8
    price: rand(10.0..100.0).round(2),
    rating: rand(1.0..5.0).round(1),
    image_url: image_url
  )

  puts "Created recommendation ##{i+1} with image URL"
end

puts "Seeding completed!"
