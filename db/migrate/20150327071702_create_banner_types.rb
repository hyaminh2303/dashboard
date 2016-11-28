class CreateBannerTypes < ActiveRecord::Migration
  def change
    create_table :banner_types do |t|
      t.string :name
      t.string :banner_type_code
    end if !(table_exists? :banner_types)
  end
end
