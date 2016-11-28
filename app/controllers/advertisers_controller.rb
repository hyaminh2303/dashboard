class AdvertisersController < ApplicationController
  before_action :set_advertiser, only: [:show, :edit, :update, :destroy]

  # GET /advertisers
  def index
    @title = I18n.t('views.advertisers.index.title')
    @grid = AdvertisersGrid.new(params[:advertisers_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /advertisers/1
  def show
    @title = I18n.translate('views.advertisers.show.title')
  end

  # GET /advertisers/new
  def new
    @title = I18n.translate('views.advertisers.new.title')
    @advertiser = Advertiser.new
  end

  # GET /advertisers/1/edit
  def edit
    @title = I18n.translate('views.advertisers.edit.title')
  end

  # POST /advertisers
  def create
    @advertiser = Advertiser.new(advertiser_params)
    @advertiser.user = current_user
    if @advertiser.save
      redirect_to @advertiser, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.advertiser.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /advertisers/1
  def update
    if @advertiser.update(advertiser_params)
      redirect_to @advertiser, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.advertiser.name'))
    else
      render :edit
    end
  end

  # POST /advertisers
  def expire
    @advertiser = Advertiser.find(params[:id])
    if @advertiser.update({:status => Advertiser::STATUS_EXPIRED})
      redirect_to advertisers_path, notice: I18n.t('messages.expire.success', :class_name => I18n.t('models.advertiser.name'))
    end
  end

  # POST /advertisers
  def publish
    @advertiser = Advertiser.find(params[:id])
    if @advertiser.update({:status => Advertiser::STATUS_PUBLISHED})
      redirect_to advertisers_path, notice: I18n.t('messages.publish.success', :class_name => I18n.t('models.advertiser.name'))
    end
  end

  # DELETE /advertisers/1
  def destroy
    @advertiser.destroy
    redirect_to advertisers_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.advertiser.name'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertiser
      @advertiser = Advertiser.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def advertiser_params
      params.require(:advertiser).permit(:name, :contact, :email, :status)
    end
end
