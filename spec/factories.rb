FactoryGirl.define do
	factory :user do
		name 				"Alejandro"
		email				"ale@gmail.com"
		password 		"foobar"
		password_confirmation "foobar"
	end
end