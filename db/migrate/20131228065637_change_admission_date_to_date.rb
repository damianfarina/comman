class ChangeAdmissionDateToDate < ActiveRecord::Migration[5.0]
  def up
    change_column(:clients, :admission_date, :date)
  end

  def down
    change_column(:clients, :admission_date, :datetime)
  end
end
