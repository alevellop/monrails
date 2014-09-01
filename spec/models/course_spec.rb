require 'spec_helper'
require 'rspec/its'

describe Course do
  let(:user) { FactoryGirl.create(:user) }
  let(:title) 			{ "Example Course" }
  let(:description) { "Lorem Ipsum"}
  before do 
    @course = user.author_of.build(title: title, description: description)
    @course.videos.build(title: "New Video", picture: File.new("/spec/fixtures/test_video.mp4"))
  end

  subject { @course }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:author) }
  it { should respond_to(:profile_course) }
  it { should respond_to(:author_id) }
  its(:author) { should eq user }
  it { should respond_to(:videos) }
  it { should respond_to(:comments)}

  it { should be_valid }

  describe "when author_id is not present" do
  	before { @course.author_id = nil }
  	it { should_not be_valid }
  end

  describe "whit blank title or description" do
  	before { @course.title = " " }
  	it { should_not be_valid }

  	before { @course.description = " " }
  	it { should_not be_valid }
  end

  describe "with title or description that is too long" do
  	before { @course.title = "a"*101 }
  	it{ should_not be_valid }

  	before { @course.description= "a"*1001 }
  	it { should_not be_valid }
  end

  describe "with video is not attached" do
    before { @course.videos = nil }
    it { should_not be_valid }
  end

  describe "with video's title empty" do
    before { @course.videos.first.title = nil }
    it { should_not be_valid }
  end

  describe "with video's title is too long" do
    before { @course.videos.first.title = "a"*101 }
    it { should_not be_valid }
  end

  describe "with video's file is not attached" do
    before { @course.videos.picture = nil }
    it { should_not be_valid }
  end

  describe "with video's format is not allowed" do
    before { @course.videos.picture = File.new("/spec/fixtures/rails.png") }
    it { should_not be_valid }
  end

  describe "with comment is empty" do
    before { @course.comments.create(body: "") }
    it { should_not be_valid }
  end

  describe "with comment is too long" do
    before { @course.comments.create(body: "a"*141) }
    it { should_not be_valid }
  end

  describe "profile associations" do
    before { @course.save }
    let!(:older_user) { FactoryGirl.create(:user) }
    let!(:newer_user) { FactoryGirl.create(:user) }
    let!(:older_profile) { @course.profile_course.build(user_id: older_user.id) } 
    let!(:newer_profile) { @course.profile_course.build(user_id: newer_user.id) } 
    
    it "should destroy associated profile" do
      profiles = @course.profile_course.to_a
      @course.destroy
      expect(profiles).not_to be_empty
      profiles.each do |profile|
        expect(Profile.where(id: profile.id)).to be_empty
        expect(older_user.profile_user.find_by(id: profile.id)).to be_nil
        expect(newer_user.profile_user.find_by(id: profile.id)).to be_nil
      end
    end
  end

  describe "delete comments" do   
    describe "as admin user" do
      let!(:admin_user) { FactoryGirl.create(:admin) }
      before do 
        visit course_path(course)
        course.comments.create(body: "This is a comment to delete")
      end

      it "should can delete a comment" do
        expect { click_button "delete" }.to change(course.comments, :count).by(-1)
      end
    end

    describe "as admin user" do
      let!(:user) { FactoryGirl.create(:user) }
      before do 
        visit course_path(course)
        course.comments.destroy
        course.comments.create(body: "This is a comment to delete")
      end

      it "should can delete a comment" do
        expect { click_button "delete" }.not_to change(course.comments, :count)
      end
    end
  end
end
