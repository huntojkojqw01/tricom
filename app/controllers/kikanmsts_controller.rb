class KikanmstsController < ApplicationController
  before_action :require_user!
  before_action :set_kikanmst, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  respond_to :html

  def index
    @kikanmsts = Kikanmst.all
    respond_with(@kikanmsts)
  end

  def show
    respond_with(@kikanmst)
  end

  def new
    @kikanmst = Kikanmst.new
    respond_with(@kikanmst)
  end

  def edit
  end

  def create
    @kikanmst = Kikanmst.new(kikanmst_params)
    @kikanmst.save
    respond_with(@kikanmst)
  end

  def update
    @kikanmst.update(kikanmst_params)
    respond_with(@kikanmst)
  end

  def destroy
    @kikanmst.destroy
    respond_with(@kikanmst)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to kikanmsts_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to kikanmsts_path
    else
      begin
        Kikanmst.transaction do
          Kikanmst.delete_all
          Kikanmst.reset_pk_sequence
          Kikanmst.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to kikanmsts_path
      end
    end
  end

  def export_csv
    @kikanmsts = Kikanmst.all

    respond_to do |format|
      format.html
      format.csv { send_data @kikanmsts.to_csv, filename: "機関マスタ.csv" }
    end
  end

  private
    def set_kikanmst
      @kikanmst = Kikanmst.find(params[:id])
    end

    def kikanmst_params
      params.require(:kikanmst).permit(:機関コード, :機関名, :備考 )
    end
end
