class Plan < ActiveRecord::Base
  has_many :subscriptions

  attr_accessible :name, :price, :interval, :stripe_id, :features, :display_order, :highlight, :trial_length

  def is_upgrade_from?(plan)
    (price || 0) >= (plan.price || 0)
  end

  def free_trial?
    trial_length > 0
  end
end
