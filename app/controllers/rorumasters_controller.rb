class RorumastersController < ApplicationController
  before_action :require_user!
  before_action :set_rorumaster, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv
  before_action :set_param, only: [ :create, :new, :show, :edit, :update, :destroy, :index]
  respond_to :json, :js
  def index
    @rorumaster = Rorumaster.all
    
  end

  def new
    @rorumaster = Rorumaster.new
    respond_with(@rorumaster)
  end

  def show
    respond_with(@rorumaster)
  end

  def create
    @rorumaster = Rorumaster.new(rorumaster_params)
    @rorumaster.save
    respond_with(@rorumaster)
  end

  def update
    @rorumaster.update(rorumaster_params)
    respond_with(@rorumaster)
  end

  def destroy
    @rorumaster.destroy
    respond_with(@rorumaster)
  end

  def ajax
    case params[:focus_field]
      when 'rorumaster_削除する'
        roruIds = params[:rorus]
        roruIds.each{ |roruId|
          Rorumaster.find_by(ロールコード: roruId).destroy
        }
        data = {destroy_success: "success"}
        respond_to do |format|
        format.json { render json: data}
      end
    end
  end
  

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to rorumasters_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
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
      format.html
      format.csv { send_data @rorumasters.to_csv, filename: "ロールマスタ.csv" }
    end
  end

  def create_roru
    @rorumaster = Rorumaster.new(rorumaster_params)
    respond_to do |format|
      if  @rorumaster.save
        format.js { render 'create_roru'}
      else
        format.js { render json: @rorumaster.errors, status: :unprocessable_entity}
      end
    end
    end

  def update_roru
    @rorumaster = Rorumaster.find(rorumaster_params[:ロールコード])
    # @eki.update(eki_params)
    # redirect_to ekis_path
    respond_to do |format|
      if  @rorumaster.update(rorumaster_params)
        format.js { render 'update_roru'}
      else
        format.js { render json: @rorumaster.errors, status: :unprocessable_entity}
      end
    end
  end
  
  private
    def set_rorumaster
      @rorumaster = Rorumaster.find(params[:id])
    end

    def rorumaster_params
      params.require(:rorumaster).permit :ロールコード, :ロール名, :序列
    end

    def set_param
      @rorumaster = Rorumaster.new()
    end
end
