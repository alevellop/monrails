require 'spec_helper'

describe "StaticPages" do
  
	#variables
	let(:base_title){ "Learning in Streaming" }

  describe "Home page" do
    it "should have the content 'Monrails'" do
      visit '/static_pages/home'
      expect(page).to have_content('Monrails')
    end

    it "should have the title 'Home'" do
    	visit '/static_pages/home'
    	expect(page).to have_title("#{base_title} | Home")
    end
  end

  describe "About page" do
  	
  	it "should have the content 'About us'" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About Us')
  	end

  	it "should have the title 'About Us" do
  		visit '/static_pages/about'
  		expect(page).to have_title("#{base_title} | About Us")
  	end
  end

  describe "Contact page" do
  	it "should have the content 'Contact'" do
  		visit '/static_pages/contact'
  		expect(page).to have_content('Contact')		
  	end

  	it "should have the title 'Contact'" do
			visit '/static_pages/contact'
			expect(page).to have_title("#{base_title} | Contact")		
  	end	
  end
end
