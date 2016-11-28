class OrderItem < ActiveRecord::Base
  include FormatNumber

  enum rate_type: [:cpc, :cpm]
  belongs_to :order

  before_save :calculate_total_budget

  def formatted_money
    format_money(order.currency.name, unit_cost)
  end

  def get_target_clicks_or_impressions
    format_number(self.target_clicks_or_impressions)
  end

  def get_total_budget
    format_money(order.currency.name, total_budget)
  end

  private
  def calculate_total_budget
    self.total_budget = if cpc?
                          (target_clicks_or_impressions * unit_cost).round(2)
                        else
                          ((target_clicks_or_impressions/1000.0) * unit_cost).round(2)
                        end
  end
end