class SetProductsPricePrecision < ActiveRecord::Migration[8.0]
  def up
    change_column :products, :price, :decimal, precision: 10, scale: 2, null: false, default: 0.0 # This allows for prices up to 99,999,999.99
  end

  def down
  end
end
