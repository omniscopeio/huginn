require 'rails_helper'

describe Authorizable do
  class TestUser
    include Authorizable
    attr_accessor :can_pass
    def can_pass?
      return can_pass
    end
  end

  class PassTheTestPolicy < Policy
    def check
      return user.can_pass?
    end
  end

  it "can check the policy" do
    user = TestUser.new
    user.can_pass = true
    expect(user).to be_allowed_to(:pass_the_test)
    user.can_pass = false
    expect(user).to_not be_allowed_to(:pass_the_test)
  end

  it "raises an error about missing policies" do
    user = TestUser.new
    expect{ user.can?(:pet_the_pony) }.to raise_error(PolicyNotFoundError, "PetThePonyPolicy is not defined")
  end
end
