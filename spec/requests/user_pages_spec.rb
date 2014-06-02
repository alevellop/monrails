require 'spec_helper'

describe "UserPages" do

	subject { page }

  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) } 
    
    before do
      sign_in user
      visit users_path
    end

    describe "users list" do
      it { should_not have_title('All users') }
      it { should_not have_content('All users') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_title('All users') }
        it { should have_content('All users') }
        
        describe "pagination" do
          before(:all) { 30.times { FactoryGirl.create(:user) } }
          after(:all) { User.delete_all }

          it { should have_selector('ul.pagination') }

          it "should list each user" do
            User.all.paginate(page: 1).each do |user|
              expect(page).to have_selector('li', text: user.name)
            end
          end
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }

    describe "should render the user's created courses" do
      before do
        2.times do |m|
          user.author_of.create(title: "Example Course #{m}")
        end
        sign_in user
        visit user_path (user)
      end

      it "should have each course exactly" do
        user.author_of.each do |created_course|
          expect(page).to have_selector('li', text: created_course.title)
        end
      end
    end

    
	end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do
  	before { visit signup_path }
  	let(:submit) { "Create my account" } 

  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button submit }.not_to change(User, :count)
  		end

  		describe "after submission" do
  			before { click_button submit }

  			it { should have_title('Sign up') }
  			it { should have_content('error') }
  		end
  	end

  	describe "with valid information" do
  		before { valid_signup }

  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end

  		describe "after saving the user" do
  			before { click_button submit }
  			let(:user) { User.find_by(email: 'user@example.com') }

  			it { should have_link('Sign out') }
        it { should have_title(user.name) }
  			it { should have_success_message('Welcome') } 
  		end
  	end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before { valid_edit(user, new_name, new_email) }

      it { should have_title(new_name) }
      it { should have_selector('div.small-12.large-12.alert-box.success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do 
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } } 
      end

      before do
        sign_in(user, no_capybara: true)
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end

  describe "courses created by an user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) } 
    let!(:course_one) { another_user.author_of.create(title: "another new course") }

    before do
      sign_in user
      visit user_path(another_user)
    end

    describe "should not be deleted by another user" do
      it { should_not have_link('delete') }
    end
  end
end
