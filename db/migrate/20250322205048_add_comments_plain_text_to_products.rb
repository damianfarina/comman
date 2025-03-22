class AddCommentsPlainTextToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :comments_plain_text, :text
  end
end
