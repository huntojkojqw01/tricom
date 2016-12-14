class SessionsController < ApplicationController
  before_action :check_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by 担当者コード:params[:session][:担当者コード]
    if user && (user.authenticate params[:session][:password])
      flash[:notice] = t "app.flash.wellcome_to"
      log_in user
    else
      flash[:danger] = t "app.flash.login_field"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def check_login
    if logged_in?
      flash[:notice] = t "app.login.logged_in"
      redirect_to main_path
    end
  end
end
