class AddZipCodeToClient < ActiveRecord::Migration
  def change
    add_column :clients, :zip_code, :string
  end
end
