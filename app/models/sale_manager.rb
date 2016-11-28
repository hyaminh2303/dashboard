class SaleManager < ActiveRecord::Base

  # Associations
  has_many :orders

  # Validations
  validates :name, presence: true
  validates :phone, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true, email: true

  # Scope
  scope :by_field, -> (field, value) { where("#{self.table_name}.#{field} LIKE ?", "%#{value}%") }

  scope :order_sale, ->  (sort_by, sort_dir) { order("#{sort_by} #{sort_dir}") }

  # Custom method
  def self.get_sale_managers(params)
    # params: name, phone, email, adress, sort_by, sort_dir
    sale_managers = SaleManager.all
    sale_managers = sale_managers.by_field('name', params[:name]) if params[:name].present?
    sale_managers = sale_managers.by_field('phone', params[:phone]) if params[:phone].present?
    sale_managers = sale_managers.by_field('email', params[:email]) if params[:email].present?
    sale_managers = sale_managers.by_field('address', params[:address]) if params[:address].present?
    sale_managers = sale_managers.order_sale(params[:sort_by], params[:sort_dir]) if params[:sort_by].present?
    sale_managers
  end
end
