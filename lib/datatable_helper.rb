class DatatableHelper
  attr_reader :records_total, :data, :order

  def initialize(params)
    @params = params
  end

  def filter(model)
    unless block_given?
      throw 'No block given'
    end

    @order = "#{yield(order_index)} #{order_sort}"
    query = model.order(@order)
    @records_total = query.length

    if length?
      @data = query
    else
      @data = query.page(page).per(length)
    end
  end

  def length
    @params[:length].to_i
  end

  def length?
    @params[:length].nil?
  end

  def draw
    @params[:draw].to_i
  end

  private

  def page
    if @params[:start].nil? or @params[:length].nil?
      return 1
    end

    (@params[:start].to_i / @params[:length].to_i) + 1
  end

  def order_sort
    if @params[:order].nil? || @params[:order]['0'][:dir].nil?
      return 'ASC'
    end

    @params[:order]['0'][:dir].upcase
  end

  def order_index
    if @params[:order].nil?
      return -1
    end

    @params[:order]['0'][:column].to_i
  end
end
