class AddEmailToClients < ActiveRecord::Migration
  def change
    add_column :clients, :email_one, :string
  end
end
