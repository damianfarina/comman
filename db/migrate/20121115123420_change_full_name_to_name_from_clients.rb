class ChangeFullNameToNameFromClients < ActiveRecord::Migration[5.0]
  def up
    rename_column :clients, :full_name, :name
  end

  def down
    rename_column :clients, :name, :full_name
  end
end
