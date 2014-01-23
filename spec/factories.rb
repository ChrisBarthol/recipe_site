#FactoryGirl.define do
#	factory :user do
#		name		"Chris Barthol"
#		email		"chris.barthol@gmail.com"
#		password	"foobar"
#		password_confirmation	"foobar"
#	end
#end

FactoryGirl.define do
  sequence(:random_number) do |n|
    @random_number ||= (1..10).to_a.shuffle
    @random_number[n]
  end

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
    	admin true
    end

    factory :user_with_recipes do
      ignore do
        posts_count 51
      end

      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:recipe, evaulator.posts_count, user: user)
      end
    end
  end

  factory :comment do
    content "Lorem ipsum"
    recipe_id 1
    user
  end

  factory :recipe do
    sequence(:name) { |n| "Recipe ##{n}" }
  	sequence(:description) { |n| "Description #{n}" }
    sequence(:direction) { |n| "Add #{n}" }

    trait :with_ingredients do
      after(:create) do |instance|
        create_list :ingredient, 2, recipe: instance
      end
    end
    user
  end

  factory :ingredient do
    name "Salt"
    quantity "1"
    unit "cup"
    recipe
  end

  factory :ingredient1 do
    name "pepper"
    quantity "2"
    unit "tsp"
  end

  factory :recipeingredient do
    sequence(:name) { |n| "Recipe ##{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:direction) { |n| "Add #{n}" }
    user
    after(:create) do |instance|
      create_list :ingredient, 2, recipe: instance
    end
  end


  factory :rating do
    ranking { FactoryGirl.generate(:random_number) }
    recipe
  end
end








