class Plan < ActiveRecord::Base
  has_many :subscriptions

  include Koudoku::Plan
  attr_accessible :name, :price, :interval, :stripe_id, :features, :display_order, :highlight
end
