require 'spec_helper'

describe "Static pages" do
  
  subject { page }

  shared_examples_for "all static pages" do

    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading) { 'Monrails' } 
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it{ should_not have_title('| Home') }

    describe "courses in Home" do
      let(:description) { "Lorem Ipsum Home Tests" } 
      let(:author)   { FactoryGirl.create(:user) } 
      let(:user_one) { FactoryGirl.create(:user) }
      let(:user_two) { FactoryGirl.create(:user) }
      let(:course_one)   { author.author_of.create(tile: "Course One", description: description) }
      let(:course_two)   { author.author_of.create(title: "Course Two", description: description) }  
      let(:course_three) { author.author_of.create(title: "Course Three", description: description) }
      let(:course_four)  { author.author_of.create(title: "Course Four", description: description) }
      let(:courses)      { [course_one, course_two, course_three, course_four] }
      before do
        courses.each do |c|
          user_one.profile_user.create(course_id: c.id)
          user_two.profile_user.create(course_id: c.id)
        end
      end
      describe "newest courses" do
        it "should show the course's box" do
          courses.each do |c|
            it { should have_selector('li.title', text: c.title) }
            it { should have_selector('li.description', text: c.description) }
            it { should have_selector('li.bullet-item', text: "#{c.profile_course.count} users") }
            it { should have_link('View', href: course_path(c)) }
          end
        end
      end

      describe "popular courses" do
        it "should show the course's box" do
          courses.each do |c|
            it { should have_selector('li.title', text: c.title) }
            it { should have_selector('li.description', text: c.description) }
            it { should have_selector('li.bullet-item', text: "#{c.profile_course.count} users") }
            it { should have_link('View', href: course_path(c)) }
          end
        end
      end 
    end
  end

  describe "About page" do
  	before { visit about_path }

    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)     { 'Contact' } 
    let(:page_title)  { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links to on the layout" do
    visit root_path

    click_link "About"
    expect(page).to have_title(full_title('About Us'))

    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))

    # To be different of the next link 'Home'
    first(:link, "Monrails").click
    expect(page).to have_title(full_title('Monrails'))

    click_link "Home"
    expect(page).to have_title(full_title('Monrails'))

    click_link "Sign up"
    expect(page).to have_title(full_title('Sign up'))
  end
end
