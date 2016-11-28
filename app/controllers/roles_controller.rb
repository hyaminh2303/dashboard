class RolesController < AuthorizationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  def index
    @title = I18n.translate('views.roles.index.title')
    @grid = RolesGrid.new(params[:roles_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /roles/1
  def show
    @title = I18n.translate('views.roles.show.title')
  end

  # GET /roles/new
  def new
    @title = I18n.translate('views.roles.new.title')
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
    @title = I18n.translate('views.roles.edit.title')
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.role.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /roles/1
  def update
    params[:role][:permission_ids] ||= []
    if @role.update(role_params)
      redirect_to roles_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.role.name'))
    else
      render :edit
    end
  end

  # DELETE /roles/1
  def destroy
    if @role.users.exists?
      redirect_to roles_url, alert: I18n.t('messages.destroy.fail.dependent', :class_name => I18n.t('models.role.name').downcase)
    else
      @role.destroy
      redirect_to roles_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.role.name'))
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name, :permission_ids => [])
    end
end
