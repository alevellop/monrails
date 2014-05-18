include ApplicationHelper

def valid_signin(user)
	fill_in "Email", 					with: user.email
	fill_in "Password",				with: user.password
	click_button 'Sign in'
end

def valid_signup
	fill_in "Name", 						with: "Example User"
	fill_in "Email", 						with: "user@example.com"
	fill_in "Password", 				with: "foobar"
	fill_in "Confirmation",			with: "foobar"
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector('div.small-12.large-12.alert-box.alert', text: message)
	end
end

RSpec::Matchers.define :have_success_message do |message|
	match do |page|
		expect(page).to have_selector('div.small-12.large-12.alert-box.success', text: message)
	end
end