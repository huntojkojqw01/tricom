class KaishamastersController < ApplicationController
  before_action :require_user!
  before_action :set_kaishamaster, only: [:show, :edit, :update, :destroy]
  before_action :set_param, only: :index
  load_and_authorize_resource except: :export_csv

  respond_to :js

  def index
    @kaishamasters = Kaishamaster.all
    respond_with(@kaishamasters)
  end

  def show
    respond_with(@kaishamaster)
  end

  def new
    @kaishamaster = Kaishamaster.new
    respond_with(@kaishamaster)
  end

  def edit
  end

  def create
    @kaishamaster = Kaishamaster.new(kaishamaster_params)
    flash[:notice] = t "app.flash.new_success" if @kaishamaster.save
    respond_with(@kaishamaster)
  end

  def update
    flash[:notice] = t "app.flash.update_success" if @kaishamaster.update(kaishamaster_params)
    respond_with(@kaishamaster)
  end

  def destroy
    @kaishamaster.destroy
    respond_with(@kaishamaster, location: kaishamasters_url)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to kaishamasters_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
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
      format.html
      format.csv { send_data @kaishamasters.to_csv, filename: "会社マスタ.csv" }
    end
  end

   def ajax
    case params[:focus_field]
      when 'kaisha_削除する'
        params[:kaishas].each {|kaisha_code|
          kaisha = Kaishamaster.find(kaisha_code)
          kaisha.destroy if kaisha
        }
        data = {destroy_success: "success"}
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end

  def create_kaisha
    @kaishamaster = Kaishamaster.new(kaishamaster_params)

    respond_to do |format|
      if  @kaishamaster.save
        format.js { render 'create_kaisha'}
      else
        format.js { render json: @kaishamaster.errors, status: :unprocessable_entity}
      end
    end
  end

  def update_kaisha
    @kaishamaster = Kaishamaster.find(kaishamaster_params[:会社コード])

    respond_to do |format|
      if  @kaishamaster.update(kaishamaster_params)
        format.js { render 'update_kaisha'}
      else
        format.js { render json: @kaishamaster.errors, status: :unprocessable_entity}
      end
    end

  end



  private
    def set_kaishamaster
      @kaishamaster = Kaishamaster.find(params[:id])
    end

    def kaishamaster_params
      params.require(:kaishamaster).permit(:会社コード, :会社名, :備考)
    end

    def set_param
      @kaishamaster = Kaishamaster.new
    end
end
