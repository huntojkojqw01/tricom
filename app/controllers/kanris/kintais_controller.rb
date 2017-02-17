class Kanris::KintaisController < ApplicationController
  before_action :require_kanriG_user!
  respond_to :json
  def index
    @shainmasters = Shainmaster.get_kubun
    if params[:date].present?
      @date = params[:date].to_date
    else
      @date = Date.today.to_date
    end
    @kintais = Kintai.get_by_mounth(@date).where.not(社員番号: (Shainmaster.all.where(区分: true).map(&:社員番号)))
    if params[:user_name].nil?
      @user_name = current_user.担当者コード
      @shainmasters = Shainmaster.all.where(社員番号: @user_name)
      @kintais = Kintai.selected_month(@user_name, @date)
    end
    if params[:user_name].present?
      @user_name = params[:user_name]
      @shainmasters = Shainmaster.all.where(社員番号: @user_name)
      @kintais = Kintai.selected_month(@user_name, @date)
    end
  end

  def show
    @shainmaster = Shainmaster.find_by id: params[:id]
    @kintais = @shainmaster.kintais
    @date = Date.today
    @date = params[:date].to_date if params[:date].present?
    check_kintai_at_day_by_user(@shainmaster.id, @date)
    @kintais = @kintais.where(日付: @date.beginning_of_month..@date.end_of_month).
      order(:日付) if params[:date].present?
  end

  def export_excel
    if params[:date].present?
      @date = params[:date].to_date
    else
      @date = Date.today.to_date
    end
    @kintais = Kintai.get_by_mounth(@date).where.not(社員番号: (Shainmaster.all.where(区分: true).map(&:社員番号)))
    if params[:shainmaster].present?
      @shainmasters = Shainmaster.all.where(社員番号: params[:shainmaster])
      @kintais = Kintai.selected_month(@shainmasters, @date)
    else
      @shainmasters = Shainmaster.get_kubun.sort_by{|shain| shain.id.to_i}
    end
    respond_to do |format|
      format.html
      format.xlsx {render xlsx: 'export_excel', filename: "管理G_勤怠_#{@date}.xlsx"}
    end
  end
end
