class Category < ActiveRecord::Base
  has_many :categories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category'

  def self.grouped
    Rails.cache.fetch(:grouped_categories) do
      groups = []
      self.where(parent_id: 0).each do |p|
        groups << [p.name, Category.select{|c| c.parent_id == p.id }]
      end
      groups
    end
  end
end
