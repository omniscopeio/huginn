require 'capybara_helper'

describe "Sign up for a new account", js: true do
  describe "from the pricing page" do
    it "prompts for a plan, credit card, and creates a user" do
      VCR.use_cassette("stripe_create_customer") do
        visit "/"
        within(".navbar") do
          click_on("Pricing")
        end

        within(".plan-primary") do
          click_on("Start 30-day Free Trial")
        end

        fill_in("Email", with: "pricing-start@exmaple.com")
        fill_in("Username", with: "pricing-start")
        fill_in("Password", with: "s3cretzz")
        fill_in("Password confirmation", with: "s3cretzz")

        click_on("Sign up")

        fill_in("Card Number", with: "4242424242424242")
        fill_in("Expiration", with: "#{2.years.from_now.strftime("%m/%y")}")
        fill_in("CVC", with: "123")
        click_on("Save Billing Information")

        expect(page).to have_text("You're Subscribed!")
      end
    end
  end

  describe "from the sign up link" do
    it "prompts for a plan, credit card, and creates a user" do
      VCR.use_cassette("stripe_create_customer") do
        visit "/"
        within("#main-content") do
          click_on("Signup")
        end

        within(".plan-primary") do
          click_on("Start 30-day Free Trial")
        end

        fill_in("Email", with: "pricing-start@exmaple.com")
        fill_in("Username", with: "pricing-start")
        fill_in("Password", with: "s3cretzz")
        fill_in("Password confirmation", with: "s3cretzz")

        click_on("Sign up")

        fill_in("Card Number", with: "4242424242424242")
        fill_in("Expiration", with: "#{2.years.from_now.strftime("%m/%y")}")
        fill_in("CVC", with: "123")
        click_on("Save Billing Information")

        expect(page).to have_text("You're Subscribed!")
      end
    end
  end
end
