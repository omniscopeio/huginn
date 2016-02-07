class Subscription < ActiveRecord::Base
  include Koudoku::Subscription
  
  belongs_to :user
  belongs_to :coupon
  attr_accessible :user_id, :plan_id, :credit_card_token, :card_type, :last_four
  
  before_destroy :cancel_subscription!
  
  def cancel_subscription!
    prepare_for_plan_change
    prepare_for_cancelation
    
    # delete the subscription.
    customer = Stripe::Customer.retrieve(self.stripe_id)
    customer.cancel_subscription

    finalize_cancelation!
    finalize_plan_change!
  end
end
