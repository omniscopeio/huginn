class UpdatePlans < ActiveRecord::Migration
  def up
    Plan.where.not(stripe_id: 'hobby-plan').destroy_all

    Plan.create do |plan|
      plan.name = 'Hobby Standard'
      plan.stripe_id = 'hobby-standard-7'
      plan.price = 7.0
      plan.interval = 'month'
      plan.features = "Unlimited Agents\n\nUnlimited Scenarios\n\nUnlimited Events"
      plan.highlight = false
      plan.display_order = 4
    end

    Plan.create do |plan|
      plan.name = 'Hobby Fast'
      plan.stripe_id = 'hobby-fast-11'
      plan.price = 11.0
      plan.interval = 'month'
      plan.features = "Unlimited Agents\n\nUnlimited Scenarios\n\nUnlimited Events\n\nPropagate Events Immediately"
      plan.highlight = false
      plan.display_order = 5
    end
  end

  class Plan < ActiveRecord::Base; end
end
