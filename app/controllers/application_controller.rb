require 'application_responder'

class ApplicationController < ActionController::Base
  include SessionsHelper
  self.responder = ApplicationResponder
  respond_to :html

  before_action :set_locale,:set_page_len
  before_action :turning_data
  helper_method :current_user
  # before_filter :current_user

  protect_from_forgery with: :exception


  # @todo enable_authorization
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t 'app.flash.access_denied'
    redirect_to root_path
  end

  # todo enable for production mode
  # rescue_from NoMethodError do |exception|
  #   redirect_to :back, :alert => exception.message
  # end

  def require_user!
    unless logged_in?
      store_location
      flash[:danger] = t 'app.login.let_login'
      redirect_to login_path
    end
  end
  # @todo record not found
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from User::NotAuthorized, with: :user_not_authorized
  def require_kanriG_user!
    # unless current_user.shainmaster.shozokumaster.所属コード == '3'
    unless current_user.admin?
      flash[:danger] = t 'app.flash.access_denied'
      redirect_to main_path
    end
  end

  private

  # Finds the User with the ID stored in the session with the key
  # :current_user_id This is a common way to handle user login in
  # a Rails application; logging in sets the session value and
  # logging out removes it.

  def set_locale
    return if current_user.nil? || current_user.shainmaster.nil?
    I18n.locale = params[:locale] || I18n.default_locale
    if logged_in?
      if !current_user.shainmaster.setting.nil?
        if !current_user.shainmaster.setting.local.nil? && current_user.shainmaster.setting.local != ''
          I18n.locale = current_user.shainmaster.setting.local
        end
      end
    end
  end

  def set_page_len
    @page_length=session[:page_length]||10
  end

  def default_url_options
    {locale: I18n.locale}
  end

	def page_title
    @pageTitle = 'TRICOM'
  end

  def record_not_found
    # render plain: '404 Not Found', status: 404
    render :file => '../../public/404.html', :status => :not_found, :layout => false
  end

  def user_not_authorized
    flash[:error] = "You don't have access to this section."
    redirect_to :back
  end

  def turning_data
    return if current_user.nil? || current_user.shainmaster.nil?
    if logged_in?
      shains = current_user.shainmaster
      if !current_user.shainmaster.setting.nil?
        if !current_user.shainmaster.setting.turning_data.nil?
          if shains.setting.turning_data
            events = shains.events.where('Date(開始) < ?',Date.today.prev_month(2).beginning_of_month)
            events.each do |event|
              event.destroy
            end
            kintais = shains.kintais.where('Date(日付) < ?',Date.today.prev_month(2).beginning_of_month)
            kintais.each do |kintai|
              kintai.destroy
            end
            keihiheads = Keihihead.where(社員番号: session[:user]).where('Date(清算予定日) < ?',Date.today.prev_month(2).beginning_of_month)
            keihiheads.each do |keihihead|
              keihihead.destroy
            end
            kairans = shains.kairan.where('Date(開始) < ?',Date.today.prev_month(2).beginning_of_month)
            kairans.each do |kairan|
              kairan.destroy
            end
            dengons = Dengon.where('社員番号 = ? or 入力者 = ?',session[:user], session[:user]).where('Date(日付) < ?',Date.today.prev_month(2).beginning_of_month)
            dengons.each do |dengon|
              dengon.destroy
            end
          end
        end
      end
    end
  end
end
