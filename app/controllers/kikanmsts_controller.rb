class KikanmstsController < ApplicationController
  before_action :require_user!
  load_and_authorize_resource except: [:export_csv, :destroy, :update]
  respond_to :js

  def index
    @kikanmsts = Kikanmst.all
    respond_with(@kikanmsts)
  end

  def create
    @kikanmst = Kikanmst.new(kikanmst_params)
    @kikanmst.save
    respond_with(@kikanmst)
  end

  def update
    @kikanmst = Kikanmst.find_by(機関コード: kikanmst_params[:機関コード])
    @kikanmst.update(kikanmst_params)
    respond_with(@kikanmst)
  end

  def destroy
    if params[:ids]
      Kikanmst.where(id: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @kikanmst = Kikanmst.find_by_id(params[:id])
      @kikanmst.destroy if @kikanmst
      respond_with(@kikanmst)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to kikanmsts_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
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
      format.csv { send_data @kikanmsts.to_csv, filename: '機関マスタ.csv' }
    end
  end

  private

  def kikanmst_params
    params.require(:kikanmst).permit(:機関コード, :機関名, :備考 )
  end

end
