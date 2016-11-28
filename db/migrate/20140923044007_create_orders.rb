class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name , size: 255
      t.belongs_to :campaign
      t.belongs_to :publisher

      t.belongs_to :user
      t.string :status
      t.timestamps
    end
  end
end
