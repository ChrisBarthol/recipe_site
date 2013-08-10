namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "chris barthol",
                 email: "chris.barthol@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    users = User.all(limit: 6)
    Recipe.create(name: "Chicken and Cheese",
                  description: "MMMmmm Good")
    99.times do |n|
      name = Faker::Name.name
      description = "This is the #{n+1} Recipe"
      Recipe.create!(name: name,
                     description: description)
    end
    recipe = Recipe.all(limit: 6)
    5.times do |n|
      name = Faker::Name.name
      quantity = "#{n}"
      recipe.each { |recipe| recipe.ingredients.create!(name: name, quantity: quantity) }
    end
  end
end






