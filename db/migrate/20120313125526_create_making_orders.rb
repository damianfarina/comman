class CreateMakingOrders < ActiveRecord::Migration
  def change
    create_table :making_orders do |t|
      t.decimal :total_weight
      t.decimal :weight_per_round
      t.integer :rounds_count
      t.text :comments

      t.timestamps
    end
  end
end
