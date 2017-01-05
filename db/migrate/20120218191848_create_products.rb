class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :formula_id

      t.timestamps
    end
  end
end
