class JptHolidayMstsController < ApplicationController
  before_action :require_user!
  before_action :set_jpt_holiday_mst, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  respond_to :js

  def index
    @jpt_holiday_msts = JptHolidayMst.all
    respond_with(@jpt_holiday_msts)
  end

  def show
    respond_with(@jpt_holiday_mst)
  end

  def new
    @jpt_holiday_mst = JptHolidayMst.new
    respond_with(@jpt_holiday_mst)
  end

  def edit
  end

  def create
    @jpt_holiday_mst = JptHolidayMst.new(jpt_holiday_mst_params)
    flash[:notice] = t "app.flash.new_success" if @jpt_holiday_mst.save
    respond_with(@jpt_holiday_mst)
  end

  def update
    flash[:notice] = t "app.flash.update_success" if @jpt_holiday_mst.update(jpt_holiday_mst_params)
    respond_with(@jpt_holiday_mst)
  end

  def destroy
    @jpt_holiday_mst.destroy
    respond_with(@jpt_holiday_mst, location: jpt_holiday_msts_path)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to jpt_holiday_msts_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to jpt_holiday_msts_path
    else
      begin
        JptHolidayMst.transaction do
          JptHolidayMst.delete_all
          JptHolidayMst.reset_pk_sequence
          JptHolidayMst.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to jpt_holiday_msts_path
      end
    end
  end

  def export_csv
    @jpt_holidays = JptHolidayMst.all
    respond_to do |format|
      format.html
      format.csv { send_data @jpt_holidays.to_csv, filename: "ジュピター休日.csv" }
    end
  end

  private
  def set_jpt_holiday_mst
    @jpt_holiday_mst = JptHolidayMst.find_by id: params[:id]
  end

  def jpt_holiday_mst_params
    params.require(:jpt_holiday_mst).permit(:event_date, :title, :description)
  end
end
