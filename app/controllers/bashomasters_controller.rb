class BashomastersController < ApplicationController
  before_action :require_user!
  skip_before_action :verify_authenticity_token
  before_action :set_kaishamst, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :set_bashomaster, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv
  respond_to :js

  def index
    @bashomasters = Bashomaster.all
  end


  def show
  end

  def new
    @bashomaster = Bashomaster.new
  end

  def edit

  end

  def create
    @bashomaster = Bashomaster.new(bashomaster_params)
    flash[:notice] = t "app.flash.new_success" if @bashomaster.save
    respond_with @bashomaster
  end

  def update
    flash[:notice] = t "app.flash.update_success" if @bashomaster.update bashomaster_params
    respond_with @bashomaster
  end

  def destroy
    @bashomaster.destroy
    respond_with @bashomaster, location: bashomasters_url
  end

  def ajax
    case params[:focus_field]
      when "bashomaster_会社コード"
        kaisha_name = Kaishamaster.find_by(code: params[:kaisha_code]).try :name
        data = {kaisha_name: kaisha_name}
        respond_to do |format|
          format.json { render json: data}
        end
      when "basho_削除する"
        params[:bashos].each {|basho_code|
          basho=Bashomaster.find(basho_code)
          basho.destroy if basho
        }
        data = {destroy_success: "success"}
        respond_to do |format|
          format.json { render json: data}
        end 
      else  
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to bashomasters_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to bashomasters_path
    else
      begin
        Bashomaster.transaction do
          Bashomaster.delete_all
          Bashomaster.reset_pk_sequence
          Bashomaster.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to bashomasters_path
      end
    end
  end

  def export_csv
    @bashomasters = Bashomaster.all

    respond_to do |format|
      format.html
      format.csv { send_data @bashomasters.to_csv, filename: "場所マスタ.csv" }
    end
  end

  private

  def bashomaster_params
    params.require(:bashomaster).permit(:場所コード, :場所名, :場所名カナ, :SUB, :場所区分,:会社コード)
  end

  def set_bashomaster
    @bashomaster = Bashomaster.find(params[:id])
  end

  def set_kaishamst
    @kaishamasters = Kaishamaster.all
  end

end
