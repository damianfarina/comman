class CreatePurchasedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :purchased_products do |t|
      t.decimal :base_cost
      t.timestamps
    end
  end
end
