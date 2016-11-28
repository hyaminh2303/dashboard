class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.string :name,       size: 255
      t.string :contact,    size: 255
      t.string :email,      size: 255

      t.string :status
      t.belongs_to :user
      t.timestamps
    end
  end
end
