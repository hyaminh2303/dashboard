module OrdersHelper
  def get_row_number(type, order)
    start_row = 31
    padding_top = 3
    additional_information = order.order_items.size + start_row + padding_top
    term_and_conditions    = additional_information + [9, (order.sub_totals.size+2)].max + padding_top
    authorization          = term_and_conditions + 12 + padding_top
    {
      additional_information: additional_information,
      term_and_conditions:    term_and_conditions,
      authorization:          authorization
    }[type.to_sym]
  end

  def default_font_name
    'Verdana'
  end

  def io_number(io_id)
    "IO No.: IO-#{Time.now.strftime('%y')}#{io_id.to_s.rjust(4, '0')}"
  end
end
