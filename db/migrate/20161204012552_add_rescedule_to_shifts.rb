class AddResceduleToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :is_reschedulable, :boolean, default: false
  end
end
