class AddCommentsPlainTextToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :comments_plain_text, :text
  end
end
