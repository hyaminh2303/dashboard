class DensitiesController < AuthorizationController
  before_action :set_density, only: [:show, :edit, :update, :destroy]

  # GET /densities
  def index
    @title = I18n.t('views.densities.index.title')
    @grid = DensitiesGrid.new(params[:densities_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /densities/1
  def show
    @title = I18n.translate('views.densities.show.title')
  end

  # GET /densities/new
  def new
    @title = I18n.translate('views.densities.new.title')
    @density = Density.new
  end

  # GET /densities/1/edit
  def edit
    @title = I18n.translate('views.densities.edit.title')
  end

  # POST /densities
  def create
    @density = Density.new(density_params)
    if @density.save
      redirect_to densities_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.density.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /densities/1
  def update
    if @density.update(density_params)
      redirect_to densities_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.density.name'))
    else
      render :edit
    end
  end

  # DELETE /densities/1
  def destroy
    # Do not allow destroy density if is Agency. this case will not happend because destroy button is already hide
    @density.destroy

    redirect_to densities_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.density.name'))
  end

  def load_in_country
    @densities = Density.where(country_code: params[:country_code])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_density
      @density = Density.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def density_params
      params.require(:density).permit(:country_code, :city_name, :density, :population, :area)
    end
end
