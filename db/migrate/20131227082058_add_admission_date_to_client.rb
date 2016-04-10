class AddAdmissionDateToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :admission_date, :datetime
  end
end
