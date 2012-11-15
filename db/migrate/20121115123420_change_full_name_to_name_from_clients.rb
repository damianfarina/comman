class ChangeFullNameToNameFromClients < ActiveRecord::Migration
  def up
    rename_column :clients, :full_name, :name
  end

  def down
    rename_column :clients, :name, :full_name
  end
end
