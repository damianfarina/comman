class AddDepartmentToVersions < ActiveRecord::Migration[8.0]
  def change
    add_column :versions, :department, :string
    add_index :versions, :department
  end
end
