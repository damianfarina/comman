class AddEmailToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :email_one, :string
  end
end
