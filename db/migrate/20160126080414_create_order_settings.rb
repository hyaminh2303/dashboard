class CreateOrderSettings < ActiveRecord::Migration
  def change
    create_table :order_settings do |t|
      t.text :key
      t.text :value
      t.integer :setting_type

      t.timestamps
    end
  end
end
