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
  end

  factory :recipe do
  	sequence(:name) 			{ |n| "Recipe #{n}" }
  	sequence(:description)		{ |n| "recipe_#{n} description"}
  end

  factory :ingredient do
    name "Salt"
    quantity "1 cup"
    recipe
  end
end








