class CreateTimezones < ActiveRecord::Migration
  def change
    create_table :timezones do |t|
      t.string :timezone_code
      t.string :name
    end if !(table_exists? :timezones)
  end
end
