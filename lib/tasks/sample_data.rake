namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example User",
													email: "example@email.com",
													password: "foobar",
													password_confirmation: "foobar",
													admin: true)
		33.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@example.com"
			password = "password"
			User.create!(name: name,
										email: email,
										password: password,
										password_confirmation: password)
		end

		users = User.all
		12.times do |m|
			part_of_title = "Example Course Number - #{m}"
			description = Faker::Lorem.paragraph(2)
			users.each do |user| 
				title = user.name << "'s " << part_of_title
				user.author_of.create!(title: title, description: description) 
			end
		end
	end
end