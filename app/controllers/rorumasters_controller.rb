class RorumastersController < ApplicationController
  before_action :require_user!
  load_and_authorize_resource except: [:export_csv, :destroy, :update]
  respond_to :json, :js

  def index
    @rorumasters = Rorumaster.all    
  end

  def create
    @rorumaster = Rorumaster.new(rorumaster_params)
    @rorumaster.save
    respond_with(@rorumaster)
  end

  def update
    @rorumaster = Rorumaster.find_by(ロールコード: rorumaster_params[:ロールコード])
    @rorumaster.update(rorumaster_params)
    respond_with(@rorumaster)
  end

  def destroy
    if params[:ids]
      Rorumaster.where(ロールコード: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @rorumaster = Rorumaster.find_by(ロールコード: params[:id])
      @rorumaster.destroy if @rorumaster
      respond_with(@rorumaster)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to rorumasters_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to rorumasters_path
    else
      begin
        Rorumaster.transaction do
          Rorumaster.delete_all
          Rorumaster.reset_pk_sequence
          Rorumaster.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to rorumasters_path
      end
    end
  end

  def export_csv
    @rorumasters = Rorumaster.all
    respond_to do |format|
      format.csv { send_data @rorumasters.to_csv, filename: 'ロールマスタ.csv' }
    end
  end

  private

  def rorumaster_params
    params.require(:rorumaster).permit :ロールコード, :ロール名, :序列
  end

end
