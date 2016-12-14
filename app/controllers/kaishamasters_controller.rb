class KaishamastersController < ApplicationController
  before_action :require_user!
  before_action :set_kaishamaster, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  respond_to :js

  def index
    @kaishamasters = Kaishamaster.all
    respond_with(@kaishamasters)
  end

  def show
    respond_with(@kaishamaster)
  end

  def new
    @kaishamaster = Kaishamaster.new
    respond_with(@kaishamaster)
  end

  def edit
  end

  def create
    @kaishamaster = Kaishamaster.new(kaishamaster_params)
    flash[:notice] = t "app.flash.new_success" if @kaishamaster.save
    respond_with(@kaishamaster)
  end

  def update
    flash[:notice] = t "app.flash.update_success" if @kaishamaster.update(kaishamaster_params)
    respond_with(@kaishamaster)
  end

  def destroy
    @kaishamaster.destroy
    respond_with(@kaishamaster, location: kaishamasters_url)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to kaishamasters_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to kaishamasters_path
    else
      begin
        Kaishamaster.transaction do
          Kaishamaster.delete_all
          Kaishamaster.reset_pk_sequence
          Kaishamaster.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to kaishamasters_path
      end
    end
  end

  def export_csv
    @kaishamasters = Kaishamaster.all

    respond_to do |format|
      format.html
      format.csv { send_data @kaishamasters.to_csv, filename: "会社マスタ.csv" }
    end
  end

  private
    def set_kaishamaster
      @kaishamaster = Kaishamaster.find(params[:id])
    end

    def kaishamaster_params
      params.require(:kaishamaster).permit(:会社コード, :会社名, :備考)
    end
end
