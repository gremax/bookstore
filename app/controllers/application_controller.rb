class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
  end

  helper_method :current_order
  helper_method :get_avatar

  def current_order
    current_user.orders.in_progress.first_or_create
  end

  protected

  def get_avatar(size = 30)
    if current_user.avatar?
      current_user.avatar.thumb
    else
      hash = Digest::MD5.hexdigest(current_user.email)
      "http://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon"
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_i18n_locale_from_params
    locale_switcher if params[:locale]
  end

  def locale_switcher
    if search_locale
      I18n.locale = params[:locale]
    else
      flash.now[:warning] = "#{params[:locale]} translation not available"
      logger.error flash.now[:warning]
    end
  end

  def search_locale
    I18n.available_locales.map(&:to_s).include?(params[:locale])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation,
               :remember_me, :avatar, :avatar_cache, :remove_avatar)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation,
               :current_password, :avatar, :avatar_cache, :remove_avatar)
    end
  end
end
