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
end
