require 'spec_helper'

describe "Profile pages" do
	subject { page }

	let(:user)	{ FactoryGirl.create(:user) }
	let(:author){ FactoryGirl.create(:user) }
	let(:course){ author.author_of.create(title: "example course", description: "lorem ipsum") }

	before { sign_in user }

	describe "profile creation (register action)" do
		before { course_path(course) }

		describe "with valid information" do

			it "should create a profile (register action)" do
				expect{ click_button("Register") }.to change(Profile, :count).by(1)
			end
		end
	end

	describe "profile destruction" do

		before { user.profile_user.create(course_id: course.id) }
		
		describe "with unregister action" do
			before { visit course_path(course) }

			it "should delete a profile" do
				expect { click_link("Unregister") }.to change(Profile, :count).by(-1)
			end
		end

		describe "with course destruction" do
			before { visit user_path(author) }

			it "should delete a profile" do
				expect { click_link("delete") }.to change(Profile, :count).by(-1)
			end
		end
	end
end