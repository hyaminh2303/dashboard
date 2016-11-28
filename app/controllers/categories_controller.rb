class CategoriesController < AuthorizationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @title = I18n.translate('views.categories.index.title')
    @grid = CategoriesGrid.new(params[:categories_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /categories/1
  def show
    @title = I18n.translate('views.categories.show.title')
  end

  # GET /categories/new
  def new
    @title = I18n.translate('views.categories.new.title')
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @title = I18n.translate('views.categories.edit.title')
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.category.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to @category, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.category.name'))
    else
      render :edit
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to categories_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.category.name'))
  end

  def list
    @categories = Category.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:name, :category_code, :parent_id)
    end
end
