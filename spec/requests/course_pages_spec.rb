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

      describe "with invalid attached file" do
        before do
          fill_in 'course_title',                       with: "Example Course"
          fill_in 'course_description',                 with: "Lorem Ipsum"
          fill_in 'course_videos_attributes_0_title',   with: "Video to show"
          fill_in 'course_videos_attributes_0_picture', with: ""
        end

        it "should not create a course" do
          expect { click_button "create course" }.not_to change(Course, :count)
        end
      end
  	end

  	describe "with valid information" do
  		
  		before do
  			fill_in 'course_title',       with: "Example Course"
  			fill_in 'course_description', with: "Lorem Ipsum"
        fill_in 'course_videos_attributes_0_title',   with: "Video to Test"
        fill_in 'course_videos_attributes_0_picture', with: File.new("/spec/fixtures/test_video.mp4")
  		end
  		it "should create a course" do
  			expect { click_button "create course" }.to change(Course, :count).by(1)
  		end
      specify { expect(user.author_of.last.video.title).to eq "Video to Test" }
  	end
  end

  describe "course destruction" do
    before { user.author_of.create(title: "Course to destroy", description: "Lorem Ipsum") }

    describe "as correct user" do
      before { visit user_path(user) }

      it "should delete a course" do
        expect { click_link "delete" }.to change(Course, :count).by(-1)
      end
    end
  end

  describe "profile page" do
    let(:course) { user.author_of.create(title: "New Course", description: "Lorem Ipsum") }
    let(:video)  { course.videos.create(title: "new video", picture: File.new("/spec/fixtures/test_video.mp4")) }
    
    before{ visit course_path(course) }

    it { should have_content(course.title) }
    it { should have_title(course.title) }
    it { should have_content(course.description) }
    it { should have_content(course.author.name) }

    describe "when user is not registered" do
      it { should have_selector('p.small-12.large-12', text: video.title)}
    end

    describe "when user is registered" do
      let(:registered_user) { FactoryGirl.create(:user) }

      before do
        registered_user.profile_user.create(course_id: course.id)
        visit course_path(course)
      end

      it { should have_link(course.videos.first.title, href: course_videos_path(video)) }

      describe "when visit the video's link" do
        before { visit course_videos_path(video)}

        it { should have_selector("video[
                controls='controls',
                height='550',
                src='https://monrails-development.s3.amazonaws.com/courses/#{course.id}/#{video.id}_test_video.mp4*',
                width='600']") }

        it { should have_link("back", href: course_path(course)) }
      end
    end

    describe "add a comment" do
      let(:user) { FactoryGirl.create(:user) }
      before { user.profile_user.create(course_id: course.id) }

      describe "with invalid information" do

        it "should not create a course" do
          expect { click_button "add comment" }.not_to change(course.comments, :count)
        end
      end

      describe "with valid information" do
        before { fill_in 'comment_body', with:'This is a comment to test course' }

        it "should create a comment" do
          expect { click_button "add comment" }.to change(course.comments, :count).by(1)
        end
      end
    end

    describe "show a comment" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        course.comments.destroy
        user.profile_user.create(course_id: course.id)

        4.times do |n|
          course.comments.create(body: "This is a comment number #{n} to show.")
        end
      end

      4.times do |n|
        it { should have_selector('blockquote', text: "This is a comment number #{n} to show.") }
      end
    end

    describe "delete a comment" do
      describe "as a admin" do
        let!(:user_admin) { FactoryGirl.create(:admin) }
        before do
          sign_in(admin)
          visit course_path(course)
          course.comments.destroy
          course.comments.create(body: "This is a comment to show.")
        end

        it { should have_selector('a.button.tiny.alert',
                                  'data-confirm' => "Are you sure?",
                                  'data-method' => "delete",
                                  text: "This is a comment to show") }
      end

      describe "as a no-admin" do
        let!(:user) { FactoryGirl.create(:user) }
        before do
          sign_in(admin)
          visit course_path(course)
          course.comments.destroy
          course.comments.create(body: "This is a comment to show.")
        end

        it { should_not have_selector('a.button.tiny.alert',
                                  'data-confirm' => "Are you sure?",
                                  'data-method' => "delete",
                                  text: "This is a comment to show") }
      end
    end
  end

  describe "newest courses list" do    
    it { should have_title('Newest Courses') }   
  end
end
