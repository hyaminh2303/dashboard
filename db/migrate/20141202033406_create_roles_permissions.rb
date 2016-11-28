class CreateRolesPermissions < ActiveRecord::Migration
  def self.up
    create_table :roles_permissions, :id => false do |t|
      t.references :role
      t.references :permission
    end
    add_index :roles_permissions, [:role_id, :permission_id]
    add_index :roles_permissions, :permission_id
  end

  def self.down
    drop_table :roles_permissions
  end
end
