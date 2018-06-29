class KouteimastersController < ApplicationController
  before_action :require_user!
  skip_before_action :verify_authenticity_token
  respond_to :js
  load_and_authorize_resource except: [:export_csv, :update, :destroy]

  def index
    @shozokus = Shozokumaster.all
    @kouteimasters = Kouteimaster.includes(:shozokumaster)
  end

  def create
    @kouteimaster = Kouteimaster.new kouteimaster_params
    flash[:notice] = t 'app.flash.new_success' if @kouteimaster.save
    respond_with @kouteimaster
  end

  def update
    @kouteimaster = Kouteimaster.find_by(工程コード: kouteimaster_params[:工程コード], 所属コード: kouteimaster_params[:所属コード])
    flash[:notice] = t 'app.flash.update_success' if @kouteimaster.update(kouteimaster_params)
    respond_with @kouteimaster
  end

  def destroy
    if params[:ids]
      Kouteimaster.find(params[:ids]).each { |koutei| koutei.destroy }
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @kouteimaster = Kouteimaster.find(params[:id])
      @kouteimaster.destroy if @kouteimaster
      respond_with @kouteimaster, location: kouteimasters_url
    end
  rescue
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to kouteimasters_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to kouteimasters_path
    else
      begin
        Kouteimaster.transaction do
          Kouteimaster.delete_all
          Kouteimaster.reset_pk_sequence
          Kouteimaster.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to kouteimasters_path
      end
    end
  end

  def export_csv
    @kouteimasters = Kouteimaster.all
    respond_to do |format|
      format.csv { send_data @kouteimasters.to_csv, filename: '工程マスタ.csv' }
    end
  end

  private

  def kouteimaster_params
    params.require(:kouteimaster).permit(:所属コード, :工程コード, :工程名)
  end

end
