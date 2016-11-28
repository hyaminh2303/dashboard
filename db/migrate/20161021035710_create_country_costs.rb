class CreateCountryCosts < ActiveRecord::Migration
  def change
    create_table :country_costs do |t|
      t.string :country_code, require: true
      t.string :country_name
      t.float :population
      t.float :cpc
      t.float :cpm
    end
  end unless (table_exists? :country_costs)
end
