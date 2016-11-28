class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :super_admin, default: 0
      t.boolean :system_role, default: 0
    end
  end
end
