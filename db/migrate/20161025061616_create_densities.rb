class CreateDensities < ActiveRecord::Migration
  def change
    create_table :densities do |t|
      t.string :country_code
      t.string :city_name
      t.float :density
      t.float :population
      t.float :area
    end

    add_index :densities, :country_code
    add_index :densities, :city_name
  end unless (table_exists? :densities)
end
