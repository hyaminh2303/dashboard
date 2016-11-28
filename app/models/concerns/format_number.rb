module FormatNumber extend ActiveSupport::Concern

  def format_money(icon, money)
    "#{icon} #{format_number(money)}"
  end

  def format_number(number)
    ActiveSupport::NumberHelper.number_to_currency(number.round(2), delimiter: ",", unit: '')
  end
  
end