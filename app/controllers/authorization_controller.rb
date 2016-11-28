class AuthorizationController < ApplicationController
  # Handle CanCan Unauthorized Access
  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_path, alert: e.message
  end

  load_and_authorize_resource
  check_authorization unless: :do_not_check_authorization?

  before_filter :load_permissions

  protected
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  #load the permissions for the current user so that UI can be manipulated
  def load_permissions
    @current_permissions = current_user.role.permissions.collect{|i| [i.subject_class, i.action]} unless current_user.nil?
  end

  private
  def do_not_check_authorization?
    respond_to?(:devise_controller?) or home_controller?
  end

  def home_controller?
    is_a?(::HomeController)
  end
end