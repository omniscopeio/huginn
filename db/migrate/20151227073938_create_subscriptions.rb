class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :stripe_id
      t.integer :plan_id
      t.string :last_four
      t.integer :coupon_id
      t.string :card_type
      t.float :current_price
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
