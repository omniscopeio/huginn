class AddTrialLengthToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :trial_length, :integer, default: 0, null: false
    Plan.find_by(stripe_id: 'hobby-plan').try(:update_column, :trial_length, 60)
    Plan.find_by(stripe_id: 'hobby-standard-7').update_column(:trial_length, 30)
    Plan.find_by(stripe_id: 'hobby-fast-11').update_column(:trial_length, 30)
  end

  class Plan < ActiveRecord::Base

  end
end
