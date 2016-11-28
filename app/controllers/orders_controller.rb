class OrdersController < AuthorizationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :export_io]

  # GET /orders
  def index
    @title = I18n.translate('views.orders.index.title')
    respond_to do |format|
      format.html
      format.json {
        @orders = Order.filter_and_search_orders(params)
      }
    end
  end

  # GET /orders/1
  def show
    @title = I18n.translate('views.orders.show.title')
  end

  # GET /orders/new
  def new
    @title = I18n.translate('views.orders.new.title')
    @order = Order.new
    @order.authorization = OrderSetting.authorization
  end

  # GET /orders/1/edit
  def edit
    @title = I18n.translate('views.orders.edit.title')
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.user = current_user
    if @order.save
      render json: { order: @order }
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: { order: @order }
    else
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.order.name')) }
      format.json { render json: { notice: 'Order was successfully deleted', status: 200 }}
    end
  end

  # GET /export_io/1
  def export_io
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename='#{@order.get_io_file_name}.xlsx'"
      }
      format.pdf {
        render :pdf => @order.get_io_file_name,
            :template => "orders/pdf_export.pdf.haml",
            :print_media_type => true,
            :page_size => "A4",
            :footer => {
              right: '[page] of [topage]',
              font_size: '7'
            }
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params[:order][:order_items] ||= []
      permited = params.require(:order).permit(:date, :campaign_name, :sale_manager_id, :agency_id, :advertiser_name, :additional_information, :authorization, :currency_id)
      order_items_params = params.require(:order).permit(order_items: [ :id, :country, :ad_format, :banner_size, :placement, :start_time, :end_time, :rate_type, :target_clicks_or_impressions, :unit_cost, :_destroy])
      subtotal_params = params.require(:order).permit(sub_totals: [:id, :sub_total_setting_id, :value, :sub_total_type, :_destroy])
      permited[:order_items_attributes] = order_items_params[:order_items]
      permited[:sub_totals_attributes] = subtotal_params[:sub_totals] || []
      permited
    end
end
