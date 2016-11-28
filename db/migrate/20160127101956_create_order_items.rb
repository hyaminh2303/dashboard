class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.string :country
      t.string :ad_format
      t.string :banner_size
      t.string :placement
      t.datetime :start
      t.datetime :end
      t.integer :rate_type
      t.integer :target_clicks_or_impressions
      t.float :unit_cost
      t.float :total_budget
      t.integer :order_id

      t.timestamps
    end
  end
end
