class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng

  # Allow additional user fields
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Get locale directly from the user model
  before_filter :set_locale, :authenticate_user!

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:password, :password_confirmation, :current_password)
    }
  end

  def set_locale
    #I18n.locale = user_signed_in? ? current_user.locale.to_sym : I18n.default_locale
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  #derive the model name from the controller. egs UsersController will return User
  def self.permission
    self.name.gsub('Controller','').singularize.split('::').last.constantize.name rescue nil
  end

  private
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
end
