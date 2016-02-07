require 'rails_helper'

describe Subscription do
  describe "clean up after User#destroy" do
    it "removes orphaned subscriptions" do
      mock(Stripe::Customer).retrieve("cus_123doreymi") {|obj| mock(obj).cancel_subscription { true }; obj }
      expect { users(:bob).destroy }.to change(Subscription, :count).by(-1)
    end
    
    it "notifies the payment gateway of subscription cancellation" do
      bob = users(:bob)
      mock(Stripe::Customer).retrieve("cus_123doreymi") {|obj| mock(obj).cancel_subscription { true }; obj }
      bob.destroy
    end
  end
end
