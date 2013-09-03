
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_recipes
    make_ingredients
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Chris Barthol",
                       email:    "chris.barthol@gmail.com",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_recipes
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.comments.create!(content: content) }
  end
  10.times do |n|
    name = Faker::Name.name
    description = Faker::Lorem.sentence(2)
    direction = Faker::Lorem.sentence(5)
    #user_id = 1
    Recipe.create!(name: name,
                     description: description, direction: direction, user_id: 1 )
    #users.each { |user| user.recipes.create!(name: name, description: description, user_id: 1) }
  end
end

def make_ingredients
  recipes = Recipe.all(limit: 6)
  5.times do
    name = Faker::Name.name
    quantity = Faker::Address.zip_code
    recipes.each { |recipe| recipe.ingredients.create!(name: name, quantity: quantity) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }

  recipes = Recipe.all
  recipe = recipes.first
  saved_recipes = recipes[2..8]
  saved_recipes.each { |recipesaved| user.recipesave!(recipesaved) }

end




