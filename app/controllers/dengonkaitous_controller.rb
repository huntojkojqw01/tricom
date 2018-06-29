class DengonkaitousController < ApplicationController
  before_action :require_user!
  respond_to :html, :js

  def index
    @dengonkaitous = Dengonkaitou.all
    respond_with(@dengonkaitous)
  end

  def create
    @dengonkaitou = Dengonkaitou.new(dengonkaitou_params)
    @dengonkaitou.save
    respond_with(@dengonkaitou, location: dengonkaitous_url)
  end

  def update
    @dengonkaitou = Dengonkaitou.find_by(id: dengonkaitou_params[:id])
    @dengonkaitou.update(dengonkaitou_params)
    respond_with(@dengonkaitou, location: dengonkaitous_url)
  end

  def destroy
    if params[:ids]
      Dengonkaitou.where(id: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @dengonkaitou = Dengonkaitou.find_by_id(params[:id])
      @dengonkaitou.destroy if @dengonkaitou
      respond_with(@dengonkaitou)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to dengonkaitous_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to dengonkaitous_path
    else
      begin
        Dengonkaitou.transaction do
          Dengonkaitou.delete_all
          Dengonkaitou.reset_pk_sequence
          Dengonkaitou.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to dengonkaitous_path
      end
    end
  end

  def export_csv
    @dengonkaitous = Dengonkaitou.all
    respond_to do |format|
      format.csv { send_data @dengonkaitous.to_csv, filename: '伝言回答マスタ.csv' }
    end
  end

  private

  def dengonkaitou_params
    params.require(:dengonkaitou).permit(:種類名, :備考, :id)
  end

end
