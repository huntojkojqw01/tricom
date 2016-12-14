class Kanris::KeihiheadsController < ApplicationController
  before_action :require_kanriG_user!
  def index
    @keihiheads = Keihihead.all.page(params[:page]).per(10) if params[:date].present? || params[:user_name].present?
    @date = params[:date].to_date if params[:date].present?
    @user_name = params[:user_name] if params[:user_name].present?
    @keihiheads = @keihiheads.all.where(日付: @date.beginning_of_month..@date.end_of_month ).
      order(:日付).page(params[:page]).per(10) if params[:date].present?
    @keihiheads = @keihiheads.where(社員番号: @user_name).
      order(:日付).page(params[:page]).per(10) if params[:user_name].present?
  end
end
