class CreateDailyEstImps < ActiveRecord::Migration
  def change
    create_table :daily_est_imps do |t|
      t.string :country_code
      t.string :country_name
      t.integer :banner_size_id
      t.string :banner_size
      t.integer :impression
    end

    add_index :daily_est_imps, [:country_code, :banner_size_id], name: 'daily_est_imps_country_code_banner_size'
  end unless (table_exists? :daily_est_imps)
end
