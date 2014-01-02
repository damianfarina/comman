class AddLastTransactionAtToClients < ActiveRecord::Migration
  def change
    add_column :clients, :last_transaction_at, :datetime
  end
end
