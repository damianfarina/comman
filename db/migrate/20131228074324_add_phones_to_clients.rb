class AddPhonesToClients < ActiveRecord::Migration
  def change
    add_column :clients, :phone_one, :string
    add_column :clients, :phone_two, :string
  end
end
