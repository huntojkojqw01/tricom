class ShozokumastersController < ApplicationController
  before_action :require_user!
  skip_before_action :verify_authenticity_token
  respond_to :js

  def index
    @shozokumasters = Shozokumaster.all
  end

  def create
    @shozokumaster = Shozokumaster.new(shozokumaster_params)
    flash[:notice] = t 'app.flash.new_success' if @shozokumaster.save
    respond_with @shozokumaster
  end

  def update
    @shozokumaster = Shozokumaster.find(shozokumaster_params[:所属コード])
    flash[:notice] = t 'app.flash.update_success' if @shozokumaster.update(shozokumaster_params)
    respond_with @shozokumaster
  end

  def destroy
    if params[:ids]
      Shozokumaster.where(id: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
        respond_to do |format|
          format.json { render json: data }
        end
    else
      @shozokumaster = Shozokumaster.find_by_id(params[:id])
      @shozokumaster.destroy if @shozokumaster
      respond_with @shozokumaster, location: shozokumasters_url
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to shozokumasters_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to shozokumasters_path
    else
      begin
        Shozokumaster.transaction do
          Shozokumaster.delete_all
          Shozokumaster.reset_pk_sequence
          Shozokumaster.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to shozokumasters_path
      end
    end
  end

  def export_csv
    @shozokumasters = Shozokumaster.all
    respond_to do |format|
      format.csv { send_data @shozokumasters.to_csv, filename: '所属マスタ.csv' }
    end
  end

  private

  def shozokumaster_params
    params.require(:shozokumaster).permit(:所属コード, :所属名)
  end

end
