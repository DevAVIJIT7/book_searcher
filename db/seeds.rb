# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'
require 'base64'

(1..50).each do 
  User.create!(email: Faker::Internet.email, password: '123456789', name: Faker::Name.name)
end
puts "Users created"

(1..1000).each do 
  Author.create!(
  	email:         Faker::Internet.email, 
  	password:      '123456789', 
  	name:          Faker::Name.name,
  	bio:           Faker::Lorem.characters(rand(51..99)),
  	profile_pic:   Base64.encode64(open(Faker::LoremPixel.image("100x100")).read),
  	academics:     Faker::Lorem.sentence,
  	awards:        Faker::Lorem.sentence
  )
end
puts "Authors created"

(1..25000).each do |i|
  Review.create!(
  	title:         "Review#{i}",
  	description:   Faker::Lorem.sentence, 
  	rating:        (1..5).to_a.sample,
  	user_id:       User.all.sample.id
  )
end
puts "Reviews created"

(1..5000).each do |i|
  book = Book.create!(
  	name:                "Book1#{i}",
  	short_description:   Faker::Lorem.sentence,
  	long_description:    Faker::Lorem.paragraph,
  	date_of_publication: Faker::Date.between(30.days.ago, Date.today),
  	genre:               "Science fiction.Satire.Drama.Action and Adventure.Romance.Mystery.Horror.Self help.Fantasy".split(".").sample(2)
  )

  book.authors << Author.all.sample(2)
  book.reviews << Review.all.sample(5)
end
puts "Books created"