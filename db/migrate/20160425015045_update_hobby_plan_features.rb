class UpdateHobbyPlanFeatures < ActiveRecord::Migration
  def change
    Plan.find_by(stripe_id: 'hobby-plan').try(:update_column, :features, "Unlimited Agents\n\nUnlimited Scenarios\n\nUnlimited Events\n\nPropagate Events Immediately")
  end

  class Plan < ActiveRecord::Base; end
end
