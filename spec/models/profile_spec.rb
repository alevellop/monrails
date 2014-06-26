require 'spec_helper'

describe Profile do
  let(:user) { FactoryGirl.create(:user) }
  let(:author) { FactoryGirl.create(:user) }
  let(:course) { author.author_of.create(title: "Example Course", description: "Lorem Ipsum") }

  before do
  	@profile = user.profile_user.build(course_id: course.id)
  end

  subject { @profile }

  it { should respond_to(:comment) }
  it { should respond_to(:user_id) }
  it { should respond_to(:course_id) }
  it { should respond_to(:user) }
  it { should respond_to(:course) }
  its(:user) 		{ should eq user }
  its(:course)	{ should eq course }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @profile.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when course_id is not present" do
  	before { @profile.course_id = nil }
  	it { should_not be_valid }
  end

  describe "when comment is too longer" do
  	before { @profile.comment = "a"*141 }
  	it { should_not be_valid }
  end
end
