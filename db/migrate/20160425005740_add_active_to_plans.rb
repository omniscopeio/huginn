class AddActiveToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :active, :boolean, default: true
    Plan.find_by(stripe_id: 'hobby-plan').try(:update_attribute, :active, false)
  end

  class Plan < ActiveRecord::Base; end
end
