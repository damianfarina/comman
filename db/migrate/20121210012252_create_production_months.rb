class CreateProductionMonths < ActiveRecord::Migration
  def change
    create_table :production_months do |t|
      t.integer :year
      t.integer :month
      t.decimal :production, :default => 0.0
      t.timestamps
    end
  end
end
