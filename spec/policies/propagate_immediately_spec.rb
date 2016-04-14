require 'rails_helper'

describe PropagateImmediatelyPolicy do
  let(:user) { User.new.tap{|u| u.subscription = subscription} }
  let(:subscription) { Subscription.new }

  it "allows grandfathered plans to use the Propagate Immediately feature" do
    user.subscription.plan = plans(:hobby_plan)
    expect(user).to be_allowed_to(:propagate_immediately)
  end

  it "allows hobby-standard-7 plans from_using the Propagate Immediately feature" do
    user.subscription.plan = plans(:hobby_standard_7)
    expect(user).not_to be_allowed_to(:propagate_immediately)
  end

  it "disallows hobby-fast-11 plans to use the Propagate Immediately feature" do
    user.subscription.plan = plans(:hobby_fast_11)
    expect(user).to be_allowed_to(:propagate_immediately)
  end

  it "disallows future plans from using the Propagate Immediately feature" do
    user.subscription.plan = Plan.new
    expect(user).not_to be_allowed_to(:propagate_immediately)
  end

  it "disallows users without subscriptions from using the Propagate Immediately feature" do
    user_without_subscription = User.new
    expect(user_without_subscription).not_to be_allowed_to(:propagate_immediately)
  end
end
