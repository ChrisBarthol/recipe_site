FactoryGirl.define do
	factory :user do
		name		"Chris Barthol"
		email		"chris.barthol@gmail.com"
		password	"foobar"
		password_confirmation	"foobar"
	end
end