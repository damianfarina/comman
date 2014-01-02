class AddAdmissionDateToClient < ActiveRecord::Migration
  def change
    add_column :clients, :admission_date, :datetime
  end
end
