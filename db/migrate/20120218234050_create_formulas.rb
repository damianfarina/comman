class CreateFormulas < ActiveRecord::Migration[5.0]
  def change
    create_table :formulas do |t|
      t.string :name
      t.string :abrasive
      t.string :grain
      t.string :hardness
      t.string :porosity
      t.string :alloy

      t.timestamps
    end
  end
end
