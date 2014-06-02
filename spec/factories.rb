FactoryGirl.define do
	factory :user, class: User do
		sequence(:name)		{ |n| "Person #{n}" }
		sequence(:email)	{ |n| "person_#{n}@example.com" }
		password 		"foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	factory :course, class: Course do
		title "Example Course"
		description "Lorem Ipsum"

		transient do
			author_id 001
		end
	end
end