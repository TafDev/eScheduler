class CreateUserShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_shifts do |t|
      t.references :user
      t.references :shift

      t.timestamps
    end
  end
end
