class UsersController < AuthorizationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @title = I18n.t('views.users.index.title')
    @grid = UsersGrid.new(params[:users_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /users/1
  def show
    @title = I18n.translate('views.users.show.title')
  end

  # GET /users/new
  def new
    @title = I18n.translate('views.users.new.title')
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @title = I18n.translate('views.users.edit.title')
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.user.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to users_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.user.name'))
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    # Do not allow destroy user if is Agency. this case will not happend because destroy button is already hide
    unless @user.is_agency?
      @user.destroy
    end

    redirect_to users_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.user.name'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :role_id)
    end
end
