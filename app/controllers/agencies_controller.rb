class AgenciesController < AuthorizationController
  before_action :set_agency, only: [:show, :edit, :update, :destroy, :enable, :disable, :send_invitation]
  skip_authorize_resource only: [:become_admin]
  # GET /agencies
  def index
    @title = I18n.translate('views.agencies.index.title')
    # @grid = AgenciesGrid.new(params[:agencies_grid]) do |scope|
    #     scope.page(params[:page])
    # end
    respond_to do |format|
      format.html
      format.json{render json: { agencies: Agency.all_agencies }}
    end
  end

  def list
    @dt = DatatableHelper.new params
    @dt.filter Agency.filter_agencies(params[:filter]) do |index|
      case index
        when 0
          'name'
        when 1
          'country_code'
        when 2
          'email'
        else
          'id'
      end
    end
  end

  def become
    return unless current_user.admin? || current_user.super_admin?
    session[:admin_id] = current_user.id
    sign_in(:user, Agency.find(params[:id]).user, bypass: true)
    redirect_to root_url
  end

  def become_admin
    return raise CanCan::AccessDenied.new('You are not authorized to access this page.') unless session[:admin_id].present?
    sign_in(:user, User.find(session[:admin_id]), bypass: true)
    session[:admin_id] = nil
    redirect_to root_url
  end

  # GET /agencies/1
  def show
    @title = I18n.translate('views.agencies.show.title')
  end

  # GET /agencies/new
  def new
    @title = I18n.translate('views.agencies.new.title')
    @agency = Agency.new
  end

  # GET /agencies/1/edit
  def edit
    @title = I18n.translate('views.agencies.edit.title')
  end

  # POST /agencies
  def create
    @agency = Agency.new(agency_params)
    if @agency.save
      redirect_to agencies_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.agency.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /agencies/1
  def update
    if @agency.update(agency_params)
      redirect_to agencies_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.agency.name'))
    else
      render :edit
    end
  end

  # DELETE /agencies/1
  def destroy
    unless @agency.campaigns.empty?
      redirect_to agencies_url, alert: I18n.t('models.agency.messages.destroy.being_used')
    else
      @agency.destroy
      redirect_to agencies_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.agency.name'))
    end
  end

  # POST /agencies/1/enable
  def enable
    @agency.update_attribute(:enabled, true)
    # redirect_to agencies_url, notice: I18n.t('messages.enable.success', name: @agency.name)
    render nothing: true, status: 200
  end

  # POST /agencies/1/disable
  def disable
    @agency.update_attribute(:enabled, false)
    # redirect_to agencies_url, notice: I18n.t('messages.disable.success', name: @agency.name)
    render nothing: true, status: 200
  end

   # POST /agencies/1/show_finance
  def show_finance
    @agency.update_attribute(:hide_finance, false)
    render nothing: true, status: 200
  end

  # POST /agencies/1/hide_finance
  def hide_finance
    @agency.update_attribute(:hide_finance, true)
    render nothing: true, status: 200
  end

  # POST /agencies/1/send_invitation
  def send_invitation
    unless @agency.enabled?
      redirect_to agencies_url, alert: I18n.t('models.agency.messages.send_invitation.not_enabled')
    end
    pwd = User.generate_password
    @agency.user.update(password: pwd, password_confirmation: pwd)

    #TODO send email
    AgencyMailer.invitation_email(@agency, pwd).deliver
    redirect_to agencies_url, notice: I18n.t('models.agency.messages.send_invitation.success', email: @agency.email)
  end

  # POST /agencies/1/reset_password
  def reset_password
    unless @agency.enabled?
      redirect_to agencies_url, alert: I18n.t('models.agency.messages.send_invitation.not_enabled')
    end

    pwd = User.generate_password
    @agency.user.update(password: pwd, password_confirmation: pwd)

    redirect_to agencies_url, notice: I18n.t('models.agency.messages.reset_password.success', password: pwd)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency
      @agency = Agency.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def agency_params
      params.require(:agency).permit(:status, :name, :country_code, :phone, :email, :address, :currency_id, :parent_id, :billing_name, :billing_phone, :billing_email, :billing_address, :use_contact_info, :channel, :contact_name, :contact_phone, :contact_email, :contact_address)
    end
end
