require 'spec_helper'

describe "Static pages" do

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('h1', text: heading) }
		it { should have_title(full_title(page_title)) }
	end

	describe "Home page" do
		before { visit root_path }

		let(:heading)		{ 'Sample App' }
		let(:page_title) 	{ '' }

		it_should_behave_like "all static pages"
		it { should_not have_title('| Home') }

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					expect(page).to have_selector("li#micropost-#{item.id}", text: item.content)
				end
			end

			describe "micropost count pluralization" do

				it "should have 2 microposts" do
					user.microposts.count == 2
				end

				it "should be plural" do
					expect(page).to have_content("2 microposts")
				end

				describe "made sigular" do
					before do 
						user.feed.last.destroy
						visit root_path
					end

					it "should be singular" do
						expect(page).to have_content("1 micropost")
					end

					describe "made zero" do
						before do 
							user.feed.last.destroy
							visit root_path
						end

						it "should be plural" do
							expect(page).to have_content("0 microposts")
						end
					end
				end
			end

			describe "pagination" do

				before do
					30.times.collect do |i| 
						FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum #{i}")
					end
					visit root_path
				end
				after { Micropost.delete_all }
				
				it { should have_selector('div.pagination') }

				it "should list each micropost" do
					user.feed.paginate(page: 1).each do |micropost|
						expect(page).to have_selector('li', text: micropost.content)
					end
				end
			end

		end
	end

	describe "Help page" do
		before { visit help_path }

		let(:heading)		{ 'Help' }
		let(:page_title)	{ 'Help' }

		it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }

		let(:heading)		{ 'About Us' }
		let(:page_title)	{ 'About Us' }
		
		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }

		let(:heading)		{ 'Contact' }
		let(:page_title)	{ 'Contact' }

		it_should_behave_like "all static pages"
	end

	it "should have the right links on the layout" do
		visit root_path
		click_link "About"
		expect(page).to have_title(full_title('About Us'))
		click_link "Help"
		expect(page).to have_title(full_title('Help'))
		click_link "Contact"
		expect(page).to have_title(full_title('Contact'))
		click_link "Home"
		click_link "Sign up now!"
		expect(page).to have_title(full_title('Sign up'))
		click_link "sample app"
		expect(page).to have_title(full_title(''))
	end
end