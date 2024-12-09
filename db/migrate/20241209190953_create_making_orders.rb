class CreateMakingOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :making_orders do |t|
      t.decimal :total_weight
      t.decimal :weight_per_round
      t.integer :rounds_count
      t.text :comments
      t.float :mixer_capacity
      t.integer :state

      t.timestamps
    end
  end
end
