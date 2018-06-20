class BunruisController < ApplicationController
  before_action :require_user!
  before_action :set_bunrui, only: [:show, :edit, :update]

  respond_to :html, :js

  def index
    @bunruis = Bunrui.all
  end

  def show
    respond_with(@bunrui)
  end

  def new
    @bunrui = Bunrui.new    
  end

  def edit
  end

  def create
    @bunrui = Bunrui.new(bunrui_params)
    flash[:notice] = t 'app.flash.new_success' if @bunrui.save
    respond_with(@bunrui)
  end

  def update
    flash[:notice] = t 'app.flash.update_success' if @bunrui.update(bunrui_params)
    respond_with(@bunrui)
  end

  def destroy
    if params[:ids]
      Bunrui.where(分類コード: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @bunrui = Bunrui.find_by(分類コード: params[:id])
      @bunrui.destroy if @bunrui
      respond_with(@bunrui)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file.nil'
      redirect_to bunruis_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to bunruis_path
    else
      begin
        Bunrui.transaction do
          Bunrui.delete_all
          Bunrui.reset_pk_sequence
          Bunrui.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to bunruis_path
      end
    end
  end

  def export_csv
    @bunruis = Bunrui.all

    respond_to do |format|
      format.html
      format.csv { send_data @bunruis.to_csv, filename: '分類マスタ.csv' }
    end
  end

  def ajax
    case params[:focus_field]
      when 'bunrui_削除する'
        bunruiIds = params[:bunruis]
        bunruiIds.each{ |bunruiId|
          Bunrui.find_by(分類コード: bunruiId).destroy
        }
        data = {destroy_success: 'success'}
        respond_to do |format|
        format.json { render json: data}
      end
    end
  end

  def create_bunrui
    @bunrui = Bunrui.new(bunrui_params)
    @bunrui.save
  end

  def update_bunrui
    @bunrui = Bunrui.find_by(分類コード: bunrui_params[:分類コード])
    @bunrui.update(bunrui_params)
  end

  private
    def set_bunrui
      @bunrui = Bunrui.find(params[:id])
    end

    def bunrui_params
      params.require(:bunrui).permit(:分類コード, :分類名)
    end
end
