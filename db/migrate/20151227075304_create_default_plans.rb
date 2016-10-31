class CreateDefaultPlans < ActiveRecord::Migration
  def up
    Plan.create({
      name: 'Free',
      price: 0,
      interval: 'month',
      stripe_id: 'free-plan',
      features: ['Unlimited Agents', 'Unlimited Scenarios', 'Unlimited Events', 'Shared Public Worker'].join("\n\n"),
      display_order: 1
    })

    Plan.create({
      name: 'Hobby',
      price: 3.00,
      interval: 'month',
      stripe_id: 'hobby-plan',
      features: ['Unlimited Agents', 'Unlimited Scenarios', 'Unlimited Events', 'Semi-Dedicated Worker'].join("\n\n"),
      display_order: 2
    })

    Plan.create({
      name: 'Professional',
      price: 12.00, 
      highlight: true, # This highlights the plan on the pricing page.
      interval: 'month',
      stripe_id: 'one-dedicated-worker-plan', 
      features: ['Unlimited Agents', 'Unlimited Scenarios', 'Unlimited Events', '1 Dedicated Worker'].join("\n\n"), 
      display_order: 3
    })
    
    Plan.create({
      name: 'Team',
      price: 55.00, 
      interval: 'month',
      stripe_id: 'five-dedicated-worker-plan', 
      features: ['Unlimited Agents', 'Unlimited Scenarios', 'Unlimited Events', '5 Dedicated Workers'].join("\n\n"), 
      display_order: 4
    })

  end
  
  private 
  class Plan < ActiveRecord::Base
    has_many :subscriptions
  end
  
  class Subscription < ActiveRecord::Base
    belongs_to :user
    belongs_to :coupon
  end
  
  class Coupon < ActiveRecord::Base
    has_many :subscriptions
  end
end
