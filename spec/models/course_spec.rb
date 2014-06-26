require 'spec_helper'

describe Course do
  let(:user) { FactoryGirl.create(:user) }
  let(:title) 			{ "Example Course" }
  let(:description) { "Lorem Ipsum"}
  before { @course = user.author_of.build(title: title, description: description) }

  subject { @course }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:author) }
  it { should respond_to(:profile_course) }
  it { should respond_to(:author_id) }
  its(:author) { should eq user }

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

  	before { @course.description= "a"*301 }
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
end
