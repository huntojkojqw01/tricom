class SessionsController < ApplicationController
  before_action :check_login, only: [:new, :create]
  require 'mail'
  def new
  end

  def send_mail
  end

  def confirm_mail
    user = User.find_by(担当者コード: params[:session][:担当者コード], email: params[:session][:email])

    if user
    #   options = { :address              => 'smtp.gmail.com',
    #               :port                 => 587,
    #               :domain               => 'heroku.com',
    #               :user_name            => 'anhmt212@gmail.com',
    #               :password             => 'password_of_mail',
    #               :authentication       => 'plain',
    #               :enable_starttls_auto => true  }

    #   Mail.defaults do
    #     delivery_method :smtp, options
    #   end
      session[:code] = random_string
      session[:user_code] = user.try(:担当者コード)
      ses = session[:code]
      if user.update(password: ses,flag_reset_password: true)
        Mail.deliver do
          to '#{user.try(:email)}'
          from 'hminhduc@gmail.com'
          subject '【勤務システム】'
          body '担当者コード : 【#{user.try(:担当者コード)}】。新しいパスワード: 【'+ses+'】。'
        end
        flash[:notice] = t 'app.login.send_mail'
        redirect_to login_path
      else
        flash[:danger] = t 'app.flash.login_field'
        render 'send_mail'
      end

    else
      flash[:danger] = t 'app.flash.login_field'
      render 'send_mail'
    end
  end

  def random_string(length = 8)
    rand(32**length).to_s(32)
  end

  def login_code
  end
  def login_code_confirm
    user = User.find_by 担当者コード:params[:session][:担当者コード]
    if user && !session[:code].nil? && params[:session][:code] == session[:code] && !session[:user_code].nil? && params[:session][:担当者コード] == session[:user_code]
      flash[:notice] = t 'app.flash.wellcome_to'
      log_in user
    else
      flash[:danger] = t 'app.flash.login_field'
      render 'login_code'
    end
  end

  def create
    user = User.find_by 担当者コード:params[:session][:担当者コード]
    if user && (user.authenticate params[:session][:password])
      flash[:notice] = t 'app.flash.wellcome_to'
      log_in user
    else
      flash[:danger] = t 'app.flash.login_field'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def check_login
    if logged_in?
      flash[:notice] = t 'app.login.logged_in'
      redirect_to main_path
    end
  end
end
