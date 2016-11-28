class AddUnitPriceToCreativeTracking < ActiveRecord::Migration
  def change
    add_column :creative_trackings, :unit_price, :float
  end
end
