class AddZipCodeToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :zip_code, :string
  end
end
