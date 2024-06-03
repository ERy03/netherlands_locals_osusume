require 'open-uri'
require 'faker'

puts "Cleaning database..."
Recommendation.destroy_all
User.destroy_all
Review.destroy_all

# Seed data
10.times do |i|

  # Generate random user using Faker
  user_name = Faker::Internet.username(specifier: 1..20)
  email = Faker::Internet.email
  password = Faker::Internet.password

  user = User.create!(
    user_name: user_name,
    email: email,
    password: password
  )

  puts "Created user ##{i+1}"

  # Generate random name and description using Faker
  name = Faker::Restaurant.name
  description = Faker::Restaurant.description
  address = Faker::Address.full_address
  date = Faker::Date.between(from: '2024-01-01', to: '2024-05-31')

  # Fetch a random image URL from Unsplash
  random_seed = SecureRandom.uuid
  image_url = "https://source.unsplash.com/random/?restaurant&#{random_seed}"

  # Create a new recommendation record
  recommendation = Recommendation.create!(
    name: name,
    user_id: user.id,
    description: description,
    visit_date: date,
    address: address,
    recommendation_type: rand(0..8), # Assuming you have 9 types from 0 to 8
    price: rand(10.0..100.0).round(2),
    rating: rand(1.0..5.0).round(1),
    image_url: image_url,
    created_at: date
  )

  puts "Created recommendation ##{i+1} with image URL"

  # Create a review
  Review.create!(
    user_id: user.id,
    recommendation_id: recommendation.id,
    text: Faker::Restaurant.review,
    rating: Faker::Number.between(from: 0, to: 5),
    visit_date: date
  )
  puts "Created review ##{i+1}"
end

puts "Seeding completed!"
