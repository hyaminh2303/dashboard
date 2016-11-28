class CreateGenders < ActiveRecord::Migration
  def change
    create_table :genders do |t|
      t.string :name
      t.string :gender_code
    end if !(table_exists? :genders)
  end
end
