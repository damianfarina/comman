class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :formula_id
      t.string :shape
      t.string :size
      t.decimal :weight
      t.string :pressure

      t.timestamps
    end
  end
end
