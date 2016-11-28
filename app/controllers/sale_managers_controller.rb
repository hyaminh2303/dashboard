class SaleManagersController < ApplicationController

  # GET /sale_managers
  def index
    respond_to do |format|
      format.html
      format.json {
        @sale_managers = SaleManager.get_sale_managers(params)
        @total = @sale_managers.count

        start = params[:start].to_i
        limit = params[:limit].to_i

        @sale_managers = @sale_managers.offset(start).limit(limit)
      }
    end
  end

  def list
    respond_to do |format|
      format.html
      format.json {
        @sale_managers = SaleManager.get_sale_managers(params)
      }
    end
  end

  # GET /sale_managers/new
  def new
    @sale_manager = SaleManager.new  
  end

  # GET /sale_managers/1/edit
  def edit
    @sale_manager = SaleManager.find params[:id]
  end

  # PATCH/PUT /sale_managers/1
  def update
    @sale_manager = SaleManager.find params[:id]
    if @sale_manager.update(sale_manager_params)
      redirect_to sale_managers_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.platform.name'))
    else
      render :edit
    end
  end

  # POST /sale_managers
  def create
    @sale_manager = SaleManager.new(sale_manager_params)
    if @sale_manager.save
      redirect_to sale_managers_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.agency.name'))
    else
      render :new
    end
  end

  # DELETE /sale_managers/1
  def destroy
    # have to implement coding condition later
    sale_manager = SaleManager.find params[:id]
    orders = sale_manager.orders
    if orders.count > 0 
      render json: { is_deleted: false }
    else
      sale_manager.destroy
      render json: { is_deleted: true }
    end
  end

  private
  def sale_manager_params
    params.require(:sale_manager).permit(:name, :phone, :email, :address)
  end
end

