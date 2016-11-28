class PlatformAddOptions < ActiveRecord::Migration
  def up
    change_table :platforms do |t|
      t.text :options, after: :name
    end
  end

  def down
    change_table :platforms do |t|
      t.remove :options
    end
  end
end
