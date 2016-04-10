class AddPhonesToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :phone_one, :string
    add_column :clients, :phone_two, :string
  end
end
