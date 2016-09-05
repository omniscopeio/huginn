require 'capybara_helper'

describe "Sign up for a new account", js: true do
  describe "signing up for free" do
    it "does not prompt for credit card info and takes the user to the agent page" do
      visit "/"
      within("#main-content") do
        click_on("Sign up")
      end

      fill_in("Email", with: "new-plan@exmaple.com")
      fill_in("Username", with: "NewPlan")
      fill_in("Password", with: "s3cretzz")
      fill_in("Password confirmation", with: "s3cretzz")
      click_on("Create Free Account")

      expect(page).to have_text("Welcome to Huginn!")
    end
  end
end
