class SetDefaultKeepEventsForToNonZero < ActiveRecord::Migration
  def change
    change_column(:agents, :keep_events_for, :integer, default: 604800)
  end
end
