class CreateManufacturedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :manufactured_products do |t|
      t.references :formula, foreign_key: true
      t.string :pressure
      t.string :shape
      t.string :size
      t.decimal :weight

      t.timestamps
    end
  end
end
