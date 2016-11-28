class CreateLocationLists < ActiveRecord::Migration
  def change
    create_table :location_lists do |t|
      t.string :name,     size: 255
      t.string :list_type,     size: 255
      t.string :status
      t.belongs_to :user

      t.timestamps
    end
  end
end
