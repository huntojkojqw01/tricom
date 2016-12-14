class EkisController < ApplicationController
  before_action :require_user!
  before_action :set_eki, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  respond_to :html

  def index
    @ekis = Eki.all
    respond_with(@ekis)
  end

  def show
    respond_with(@eki)
  end

  def new
    @eki = Eki.new
    respond_with(@eki)
  end

  def edit
  end

  def create
    @eki = Eki.new(eki_params)
    flash[:notice] = t 'app.flash.new_success' if @eki.save
    respond_with(@eki)
  end

  def update
    flash[:notice] = t 'app.flash.update_success' if @eki.update(eki_params)
    respond_with(@eki)
  end

  def destroy
    @eki.destroy
    respond_with(@eki)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to ekis_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to ekis_path
    else
      begin
        Eki.transaction do
          Eki.delete_all
          Eki.reset_pk_sequence
          Eki.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to ekis_path
      end
    end
  end

  def export_csv
    @ekis = Eki.all

    respond_to do |format|
      format.html
      format.csv { send_data @ekis.to_csv, filename: "駅マスタ.csv" }
    end
  end

  private
    def set_eki
      @eki = Eki.find(params[:id])
    end

    def eki_params
      params.require(:eki).permit(:駅コード, :駅名, :駅名カナ)
    end
end
