class RenameRichTextDescriptionToComments < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE action_text_rich_texts
      SET name = 'comments'
      WHERE name = 'description'
    SQL
  end

  def down
    execute <<~SQL
      UPDATE action_text_rich_texts
      SET name = 'description'
      WHERE name = 'comments'
    SQL
  end
end
