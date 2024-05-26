puts "Cleaning database..."
User.destroy_all
Recommendation.destroy_all

puts "Creating user..."

user = User.create!(
  email: "test@test.com",
  user_name: "Bob",
  password: '123456',
)

Recommendation.create!(
  name: "Winkel 43",
  user_id: user.id,
  description: "The Noordermarkt, in the heart of the Jewish quarter the 'Jordaan', is known for its friendly and relaxed atmosphere. Right on the corner – where the Westerstraat runs into the the Noordermarkt - Winkel43 has been established in an attractive house, which was built in traditional Amsterdam. fashion. Because of its privileged location you will be able to enjoy a cup of coffee or lunch on our terrace on sunny days all year round. The restaurant opens early in the morning till ten in the evening, but the bar won’t close until midnight.",
  address: "some where",
  recommendation_type: 1,
  price: 10,
  rating: 4.2
)

puts "Finished"
