class CreateOs < ActiveRecord::Migration
  def change
    create_table :os do |t|
      t.string :os_code
      t.string :name
    end
  end
end
