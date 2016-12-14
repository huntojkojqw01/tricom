class BashokubunmstsController < ApplicationController
  before_action :require_user!
  before_action :set_bashokubunmst, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @bashokubunmsts = Bashokubunmst.all
    respond_with(@bashokubunmsts)
  end

  def show
    respond_with(@bashokubunmst)
  end

  def new
    @bashokubunmst = Bashokubunmst.new
    respond_with(@bashokubunmst)
  end

  def edit
  end

  def create
    @bashokubunmst = Bashokubunmst.new(bashokubunmst_params)
    flash[:notice] = t 'app.flash.new_success' if @bashokubunmst.save
    respond_with(@bashokubunmst)
  end

  def update
    flash[:notice] = t 'app.flash.update_success' if @bashokubunmst.update(bashokubunmst_params)
    respond_with(@bashokubunmst)
  end

  def destroy
    @bashokubunmst.destroy
    respond_with(@bashokubunmst)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to bashokubunmsts_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to bashokubunmsts_path
    else
      begin
        Bashokubunmst.transaction do
          Bashokubunmst.delete_all
          Bashokubunmst.reset_pk_sequence
          Bashokubunmst.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to bashokubunmsts_path
      end
    end
  end

  def export_csv
    @bashokubunmsts = Bashokubunmst.all

    respond_to do |format|
      format.html
      format.csv { send_data @bashokubunmsts.to_csv, filename: "場所区分マスタ.csv" }
    end
  end

  private
    def set_bashokubunmst
      @bashokubunmst = Bashokubunmst.find(params[:id])
    end

    def bashokubunmst_params
      params.require(:bashokubunmst).permit(:場所区分コード, :場所区分名)
    end
end
