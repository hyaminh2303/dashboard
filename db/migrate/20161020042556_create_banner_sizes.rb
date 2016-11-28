class CreateBannerSizes < ActiveRecord::Migration
  def change
    create_table :banner_sizes do |t|
      t.string :name
      t.string :size
    end
  end unless (table_exists? :banner_sizes)
end
