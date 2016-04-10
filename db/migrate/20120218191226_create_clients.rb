class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :full_name
      t.string :address

      t.timestamps
    end
  end
end
