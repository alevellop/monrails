require 'spec_helper'

describe "Course pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) } 
  before { sign_in user }

  describe "course creation" do
  	before { visit new_course_path }

  	describe "with invalid information" do
  		
  		it "should not create a course" do
  			expect { click_button "create course" }.not_to change(Course, :count)
  		end

  		describe "error messages" do
  			before { click_button "create course" }
  			it { should have_content('error') }
  		end
  	end

  	describe "with valid information" do
  		
  		before do
  			fill_in 'course_title',       with: "Example Course"
  			fill_in 'course_description', with: "Lorem Ipsum"
  		end
  		it "should create a course" do
  			expect { click_button "create course" }.to change(Course, :count).by(1)
  		end
  	end
  end

  describe "course destruction" do
    before { user.author_of.create(title: "Course to destroy") }

    describe "as correct user" do
      before { visit user_path(user) }

      it "should delete a course" do
        expect { click_link "delete" }.to change(Course, :count).by(-1)
      end
    end
  end
end