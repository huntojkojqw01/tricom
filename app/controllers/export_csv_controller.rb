class ExportCsvController < ApplicationController
  before_action :require_user!
  before_action :check_user, only: :index
  def index
  end

  private
  def check_user
    redirect_to root_path if !current_user.admin? && !current_user.supervisor?
  end
end
