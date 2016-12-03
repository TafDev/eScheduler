class AddNameToRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :name, :string
  end
end
