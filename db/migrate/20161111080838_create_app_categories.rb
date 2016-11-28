class CreateAppCategories < ActiveRecord::Migration
  def change
    create_table :app_categories do |t|
      t.string :name
      t.string :code

      t.timestamps
    end unless table_exists?(:app_categories)
  end
end
