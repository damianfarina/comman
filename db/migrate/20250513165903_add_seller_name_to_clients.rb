class AddSellerNameToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :seller_name, :string
  end
end
