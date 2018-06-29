class KaishamastersController < ApplicationController
  before_action :require_user!
  load_and_authorize_resource except: [:export_csv, :destroy, :update]
  respond_to :js

  def index
    @kaishamasters = Kaishamaster.all
    respond_with(@kaishamasters)
  end

  def create
    @kaishamaster = Kaishamaster.new(kaishamaster_params)
    flash[:notice] = t 'app.flash.new_success' if @kaishamaster.save
    respond_with(@kaishamaster)
  end

  def update
    @kaishamaster = Kaishamaster.find_by(会社コード: kaishamaster_params[:会社コード])
    flash[:notice] = t 'app.flash.update_success' if @kaishamaster.update(kaishamaster_params)
    respond_with(@kaishamaster)
  end

  def destroy
    if params[:ids]
      Kaishamaster.where(id: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @kaishamaster = Kaishamaster.find_by_id(params[:id])
      @kaishamaster.destroy if @kaishamaster
      respond_with(@kaishamaster, location: kaishamasters_url)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to kaishamasters_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
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
      format.csv { send_data @kaishamasters.to_csv, filename: '会社マスタ.csv' }
    end
  end

  private

  def kaishamaster_params
    params.require(:kaishamaster).permit(:会社コード, :会社名, :備考)
  end

end
