class CountryCostsController < AuthorizationController
  before_action :set_country_cost, only: [:show, :edit, :update, :destroy]

  # GET /country_costs
  def index
    @title = I18n.t('views.country_costs.index.title')
    @grid = CountryCostsGrid.new(params[:country_costs_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /country_costs/1
  def show
    @title = I18n.translate('views.country_costs.show.title')
  end

  # GET /country_costs/new
  def new
    @title = I18n.translate('views.country_costs.new.title')
    @country_cost = CountryCost.new
  end

  # GET /country_costs/1/edit
  def edit
    @title = I18n.translate('views.country_costs.edit.title')
  end

  # POST /country_costs
  def create
    @country_cost = CountryCost.new(country_cost_params)
    if @country_cost.save
      redirect_to country_costs_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.country_cost.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /country_costs/1
  def update
    if @country_cost.update(country_cost_params)
      redirect_to country_costs_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.country_cost.name'))
    else
      render :edit
    end
  end

  # DELETE /country_costs/1
  def destroy
    # Do not allow destroy country_cost if is Agency. this case will not happend because destroy button is already hide
    @country_cost.destroy

    redirect_to country_costs_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.country_cost.name'))
  end

  def list
    @country_costs = CountryCost.all.order(country_name: :asc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country_cost
      @country_cost = CountryCost.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def country_cost_params
      return {} if params[:country_cost][:country_code].blank?

      params[:country_cost][:country_name] = Country[params[:country_cost][:country_code]].name
      params.require(:country_cost).permit(:population ,:country_code, :country_name, :cpc, :cpm)
    end
end
