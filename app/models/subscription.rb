class Subscription < ActiveRecord::Base
  include Koudoku::Subscription
  
  belongs_to :user
  belongs_to :coupon
  attr_accessible :user_id, :plan_id, :credit_card_token, :card_type, :last_four
end
