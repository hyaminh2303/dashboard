class SubTotal < ActiveRecord::Base
  include FormatNumber

  enum sub_total_type: [:fixed, :percent]
  belongs_to :order
  belongs_to :sub_total_setting

  before_save :calculate_budget_value

  def get_budget
    format_money(order.currency.name, budget)
  end

  def calculate_budget_value
    self.budget = if percent? 
                    (order.total_budget * value)/100
                  else
                    value
                  end
  end
end


