class SetsubisController < ApplicationController
  before_action :require_user!
  before_action :set_setsubi, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv
  before_action :set_param, only: [ :create, :new, :show, :edit, :update, :destroy, :index]
  respond_to :html, :js

  def index
    @setsubi = Setsubi.all
    
  end

  def show
    respond_with(@setsubi)
  end

  def new
    @setsubi = Setsubi.new
    respond_with(@setsubi)
  end

  def edit
  end

  def create
    @setsubi = Setsubi.new(setsubi_params)
    @setsubi.save
    respond_with(@setsubi)
  end

  def update
    @setsubi.update(setsubi_params)
    respond_with(@setsubi)
  end

  def destroy
    @setsubi.destroy
    respond_with(@setsubi)
  end



  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to setsubis_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to setsubis_path
    else
      begin
        Setsubi.transaction do
          Setsubi.delete_all
          Setsubi.reset_pk_sequence
          Setsubi.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to setsubis_path
      end
    end
  end

  def export_csv
    @setsubis = Setsubi.all

    respond_to do |format|
      format.html
      format.csv { send_data @setsubis.to_csv, filename: "設備マスタ.csv" }
    end
  end

  def ajax
    case params[:focus_field]
      when 'setsubi_削除する'
        setsubiIds = params[:setsubis]
        setsubiIds.each{ |setsubiId|
          Setsubi.find_by(設備コード: setsubiId).destroy
        }
        data = {destroy_success: "success"}
        respond_to do |format|
        format.json { render json: data}
      end
    end
  end

    def create_setsubi
    @setsubi = Setsubi.new(setsubi_params)
    respond_to do |format|
      if  @setsubi.save
        format.js { render 'create_setsubi'}
      else
        format.js { render json: @setsubi.errors, status: :unprocessable_entity}
      end
    end
    end

  def update_setsubi
    @setsubi = Setsubi.find(setsubi_params[:設備コード])
    # @eki.update(eki_params)
    # redirect_to ekis_path
    respond_to do |format|
      if  @setsubi.update(setsubi_params)
        format.js { render 'update_setsubi'}
      else
        format.js { render json: @setsubi.errors, status: :unprocessable_entity}
      end
    end
  end

  private
    def set_setsubi
      @setsubi = Setsubi.find(params[:id])
    end

    def setsubi_params
      params.require(:setsubi).permit(:設備コード, :設備名, :備考)
    end

    def set_param
      @setsubi = Setsubi.new()
    end
end
