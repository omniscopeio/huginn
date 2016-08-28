class RemoveForeverFromEventRetention < ActiveRecord::Migration
  def change
    Agent.where(keep_events_for: 0).update_all(keep_events_for: 30.days)
  end
end
