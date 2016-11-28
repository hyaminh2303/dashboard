class BannerSizesController < AuthorizationController
  before_action :set_banner_size, only: [:show, :edit, :update, :destroy]

  # GET /banner_sizes
  def index
    @title = I18n.t('views.banner_sizes.index.title')
    @grid = BannerSizesGrid.new(params[:banner_sizes_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /banner_sizes/1
  def show
    @title = I18n.translate('views.banner_sizes.show.title')
  end

  # GET /banner_sizes/new
  def new
    @title = I18n.translate('views.banner_sizes.new.title')
    @banner_size = BannerSize.new
  end

  # GET /banner_sizes/1/edit
  def edit
    @title = I18n.translate('views.banner_sizes.edit.title')
  end

  # POST /banner_sizes
  def create
    @banner_size = BannerSize.new(banner_size_params)
    if @banner_size.save
      redirect_to banner_sizes_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.banner_size.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /banner_sizes/1
  def update
    if @banner_size.update(banner_size_params)
      redirect_to banner_sizes_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.banner_size.name'))
    else
      render :edit
    end
  end

  # DELETE /banner_sizes/1
  def destroy
    # Do not allow destroy banner_size if is Agency. this case will not happend because destroy button is already hide
    @banner_size.destroy

    redirect_to banner_sizes_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.banner_size.name'))
  end

  def list
    @banner_sizes = BannerSize.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner_size
      @banner_size = BannerSize.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def banner_size_params
      params.require(:banner_size).permit(:name, :size)
    end
end
