class RenameMakingOrdersCommentsToCommentsPlainText < ActiveRecord::Migration[8.0]
  def change
    rename_column :making_orders, :comments, :comments_plain_text
  end
end
