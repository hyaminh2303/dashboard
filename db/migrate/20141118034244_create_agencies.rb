class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :country_code, limit: 2
      t.string :email
      t.belongs_to :user,    size: 11
      t.boolean :enabled, default: 1

      t.timestamps
    end
  end
end
