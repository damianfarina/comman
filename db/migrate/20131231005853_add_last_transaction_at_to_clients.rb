class AddLastTransactionAtToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :last_transaction_at, :datetime
  end
end
