class CreateAgeRanges < ActiveRecord::Migration
  def change
    create_table :age_ranges do |t|
      t.string :age_range_code
      t.string :name
    end
  end
end
