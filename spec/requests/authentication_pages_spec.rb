require 'spec_helper'

describe "Authentication" do
	
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		it { should have_title('Sign in')}
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in"}

			it { should have_title('Sign in') }
			it { should have_selector('div.small-12.large-12.alert-box.alert')}

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.small-12.large-12.alert-box.alert') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { valid_signin(user) }

			it { should 		have_title(user.name) }
			it { should_not have_link('Users',		href: users_path) }
			it { should 		have_link('Profile', 	href: user_path(user)) }
			it { should 		have_link('Settings', href: edit_user_path(user))}
			it { should 		have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', 	href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end

		describe "for signed_in users" do
			let(:user) { FactoryGirl.create(:user) } 
			before { sign_in(user, no_capybara: true)}

			describe "using a 'new' action" do
				before { get new_user_path }
				specify { response.should redirect_to(root_path) }
			end

			describe "using a 'create' action" do
				before do
					@user_new = {name: "Example User",
											email: "user@example.com",
											password: "foobar",
											password_confirmation: "foobar"}
					post users_path, user: @user_new
				end

				specify { response.should redirect_to(root_path) }
			end
		end
	end

	describe "authorization" do
		
		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					valid_signin(user)
				end

				describe "after signing in" do
					
					it "should render the desired protected page" do
						expect(page).to have_title('Edit user')
					end

					describe "after signing in" do
						
						it "should render the desired protected page" do
							expect(page).to have_title('Edit user')
						end

						describe "when signing in again" do
							before do
								click_link "Sign out"
								visit signin_path
								valid_signin(user)
							end

							it "should render the default (profile) page" do
								expect(page).to have_title(user.name)
							end
						end
					end
				end
			end

			describe "when visiting a non-protected page" do
				before { visit user_path(user) }

				it { should_not have_link('Users') }
			  it { should_not have_link('Profile') }
			  it { should_not have_link('Settings') }
			  it { should_not have_link('Sign out', href: signout_path) }
			  it { should 		have_link('Sign in', 	href: signin_path) }
			end

			describe "in the Users controller" do
				
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end

			describe "in the Courses controller" do
				
				describe "submitting to the create action" do
					before { post courses_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete course_path(user.author_of.create(title: "Example Course", description: "Lorem Ipsum")) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end

			describe "in the Profiles controller" do
				describe "submitting to the create action (register action)" do
					before { post profiles_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the destroy action (unregister action)" do
					let!(:author) { FactoryGirl.create(:user) }
					let!(:course) { author.author_of.create(title: "example", description: "lorem ipsum") }
					
					before { delete profile_path(user.profile_user.create(course_id: course.id)) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) } 
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@email.com") }
			before { sign_in(user, no_capybara: true) }

			describe "submitting a GET request to the Users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "submitting a PATCH request to the Users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) } 
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in(non_admin, no_capybara: true) }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "as admin user" do
			let(:admin) { FactoryGirl.create(:admin) }
			before { sign_in(admin) }

			it { should have_link('Users',		href: users_path) }

			describe "should not be able to delete himself by submitting a DELETE request to the Users#destroy action" do
				specify do
					expect { delete user_path(admin) }.not_to change(User, :count).by(-1)
				end
			end
		end
	end
end