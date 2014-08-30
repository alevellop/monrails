require 'spec_helper'
require 'rspec/its'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:author_of) }
  it { should respond_to(:profile_user) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }

    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }

    it { should_not be_valid}
  end

  describe "when email is not present" do
    before { @user.email = " " }

    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    
    it "should be invalid" do

      addresses = %w[user@foo,com user_at_foo.org 
        exapmle.user@foo.foo@bar_baz.com foo@bar+baz.com foo@bar..com]

      addresses.each do |invalid_address|
        
        @user.email = invalid_address

        expect(@user).not_to be_valid
      end
    end
  end

  it "when email format is valid" do
    
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

    addresses.each do |valid_address|
      
      @user.email = valid_address

      expect(@user).to be_valid
    end
  end

  describe "when email address is already taken" do
    let(:user_with_same_email) { @user.dup } 
    
    it "should not be valid" do
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
      
      expect(user_with_same_email).not_to be_valid
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                      password: " ", password_confirmation: " ")
    end

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }

    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }

    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
       it { should eq found_user.authenticate(@user.password) }
     end

     describe "with invalid password" do
       let(:user_for_invalid_password) { found_user.authenticate("invalid") }

       it { should_not eq user_for_invalid_password }
       specify { expect(user_for_invalid_password).to be_false } 
     end
  end

  describe "photo attribute" do
    
    describe "when photo is not uploaded" do
      
      it { should_not have_attached_file(:photo)}
    end

    describe "when photo is uploaded" do
      let(:new_photo) { File.new("/spec/fixtures/rails.png") } 
      before { @user.photo = new_photo }

      it { should validate_attachment_size(:photo).less_than(2.megabytes) }
      it { should validate_attachment_content_type(:photo).allowing("image/jpg", "image/jpeg", "image/png") }

      it "should show the correct image" do
        before { @user.save }
        expect(@user.photo).to eq new_photo
      end

      it { should have_attached_file(:photo)}
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "course associations" do
    before { @user.save }
    let!(:older_course) do
      @user.author_of.create(title: "Example Older Course")
    end
    let!(:newer_course) do
      @user.author_of.create(title: "Example Newer Course")
    end

    it "should destroy associated courses" do
      courses = @user.author_of.to_a
      @user.destroy
      expect(courses).not_to be_empty
      courses.each do |course|
        expect(Course.where(id: course.id)).to be_empty
      end
    end

    describe "status" do
      let(:another_user)   { FactoryGirl.create(:user) }
      let(:another_course) { another_user.author_of.create(title: "This is another Course") }

      its(:author_of) { should     include(newer_course) }
      its(:author_of) { should     include(older_course) }
      its(:author_of) { should_not include(another_course) }
    end
  end

  describe "profile association" do
    before { @user.save }
    let!(:author) { FactoryGirl.create(:user) }
    let!(:older_course) { author.author_of.create(title: "Example Older Course", description: "Lorem Ipsum") }
    let!(:newer_course) { author.author_of.create(title: "Example Newer Course", description: "Lorem Ipsum") }
    let!(:older_profile) { @user.profile_user.build(course_id: older_course.id) }
    let!(:newer_profile) { @user.profile_user.build(course_id: newer_course.id) }

    it "should destroy associated profiles" do
      profiles = @user.profile_user.to_a
      @user.destroy
      expect(profiles).not_to be_empty
      profiles.each do |profile|
        expect(Profile.where(id: profile.id)).to be_empty
        expect(older_course.profile_course.find_by(id: profile.id)).to be_nil
        expect(newer_course.profile_course.find_by(id: profile.id)).to be_nil
      end
    end
  end
end
