#FactoryGirl.define do
#	factory :user do
#		name		"Chris Barthol"
#		email		"chris.barthol@gmail.com"
#		password	"foobar"
#		password_confirmation	"foobar"
#	end
#end

FactoryGirl.define do
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

  factory :recipe do
    sequence(:name) { |n| "Recipe ##{n}" }
  	sequence(:description) { |n| "Description #{n}" }
    user
  end

  factory :ingredient do
    name "Salt"
    quantity "1 cup"
    recipe
  end
end








