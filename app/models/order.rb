class Order < ActiveRecord::Base
  include FormatNumber
  belongs_to :user
  belongs_to :campaign
  belongs_to :publisher
  belongs_to :sale_manager
  belongs_to :agency
  belongs_to :currency
  has_many :order_items, dependent: :destroy
  has_many :sub_totals, dependent: :destroy

  accepts_nested_attributes_for :order_items, :sub_totals, allow_destroy: true

  scope :by_agency, -> (agency_id) { where(agency_id: agency_id) }
  scope :by_sale_manager, -> (sale_manager_id) { where(sale_manager_id: sale_manager_id) }

  before_save :calculate_total_budget
  after_save do
    sub_totals.each do |s|
      s.update({})
    end
  end

  def get_total_budget
    total_budget = order_items.sum(:total_budget)
    format_money(currency.name, total_budget)
  end

  def get_total_subtotal
    total = order_items.sum(:total_budget) + sub_totals.sum(:budget)
    format_money(currency.name, total)
  end

  class << self
    def filter_and_search_orders(params)
      orders = all
      start = params[:start].to_i
      limit = params[:limit].to_i

      if params[:sort_by].present?
        orders = orders.order("#{params[:sort_by]} #{params[:sort_dir]}")
      else
        orders = orders.order("created_at #{params[:sort_dir]}")
      end
      orders = orders.by_agency(params[:agency_id]) if params[:agency_id].present?
      orders = orders.by_sale_manager(params[:sale_manager_id]) if params[:sale_manager_id].present?
      orders.offset(start).limit(limit)
    end
  end

  def net_total_budget
    (total_budget + sub_totals.sum(:budget)).round(3)
  end

  def get_io_file_name
    "YOOSE_" + self.campaign_name.downcase.gsub(' ', '_')
  end

  private
  def calculate_total_budget
    self.total_budget = order_items.to_a.inject(0) { |sum, oi| sum += (oi.cpc? ? oi.target_clicks_or_impressions : oi.target_clicks_or_impressions/1000.0) * oi.unit_cost }
  end
end
