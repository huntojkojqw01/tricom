class ShoninshamstsController < ApplicationController
  before_action :require_user!
  before_action :set_shoninshamst, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  respond_to :html

  def index
    @shoninshamsts = Shoninshamst.all
    respond_with(@shoninshamsts)
  end

  def show
    respond_with(@shoninshamst)
  end

  def new
    # @shoninshamst = Shoninshamst.new
    respond_with(@shoninshamst)
  end

  def edit
  end

  def create
    @shoninshamst = Shoninshamst.new(shoninshamst_params)
    if @shoninshamst.save
      flash[:notice] = t 'app.flash.update_success'
      respond_with(@shoninshamst)
    else
      render :new
    end
  end

  def update
    @shoninshamst.update(shoninshamst_params)
    respond_with(@shoninshamst)
  end

  def destroy
    @shoninshamst.destroy
    respond_with(@shoninshamst)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to shoninshamsts_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to shoninshamsts_path
    else
      begin
        Shoninshamst.transaction do
          Shoninshamst.delete_all
          Shoninshamst.reset_pk_sequence
          Shoninshamst.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to shoninshamsts_path
      end
    end
  end

  def export_csv
    @shoninshamsts = Shoninshamst.all

    respond_to do |format|
      format.html
      format.csv { send_data @shoninshamsts.to_csv, filename: "承認者マスタ.csv" }
    end
  end

  private
    def set_shoninshamst
      @shoninshamst = Shoninshamst.find(params[:id])
    end

    def shoninshamst_params
      params.require(:shoninshamst).permit(:申請者, :承認者, :順番)
    end
end
