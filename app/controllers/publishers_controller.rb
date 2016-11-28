class PublishersController < ApplicationController
  before_action :set_publisher, only: [:show, :edit, :update, :destroy]

  # GET /publishers
  def index
    @title = I18n.translate('views.publishers.index.title')
    @grid = PublishersGrid.new(params[:publishers_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /publishers/1
  def show
    @title = I18n.translate('views.publishers.show.title')
  end

  # GET /publishers/new
  def new
    @title = I18n.translate('views.publishers.new.title')
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
    @title = I18n.translate('views.publishers.edit.title')
  end

  # POST /publishers
  def create
    @publisher = Publisher.new(publisher_params)
    @publisher.user = current_user
    if @publisher.save
      redirect_to @publisher, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.publisher.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /publishers/1
  def update
    if @publisher.update(publisher_params)
      redirect_to @publisher, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.publisher.name'))
    else
      render :edit
    end
  end

  # POST /publishers
  def expire
    @publisher = Publisher.find(params[:id])
    if @publisher.update({:status => Publisher::STATUS_EXPIRED})
      redirect_to publishers_path, notice: I18n.t('messages.expire.success', :class_name => I18n.t('models.publisher.name'))
    end
  end

  # POST /publishers
  def publish
    @publisher = Publisher.find(params[:id])
    if @publisher.update({:status => Publisher::STATUS_PUBLISHED})
      redirect_to publishers_path, notice: I18n.t('messages.publish.success', :class_name => I18n.t('models.publisher.name'))
    end
  end

  # DELETE /publishers/1
  def destroy
    @publisher.destroy
    redirect_to publishers_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.publisher.name'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publisher
      @publisher = Publisher.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def publisher_params
      params.require(:publisher).permit(:status, :name, :email )
    end
end
