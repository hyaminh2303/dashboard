class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :country_code, :null => false
      t.string :name, :null => false
      t.timestamps
    end
  end
end
