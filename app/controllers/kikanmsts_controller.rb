class KikanmstsController < ApplicationController
  before_action :require_user!
  before_action :set_kikanmst, only: [:show, :edit, :update, :destroy]
  before_action :set_param, only: [ :create, :new, :show, :edit, :update, :destroy, :index]
  load_and_authorize_resource except: :export_csv

  respond_to :html

  def index
    @kikanmsts = Kikanmst.all
    respond_with(@kikanmsts)
  end

  def show
    respond_with(@kikanmst)
  end

  def new
    @kikanmst = Kikanmst.new
    respond_with(@kikanmst)
  end

  def edit
  end

  def create
    @kikanmst = Kikanmst.new(kikanmst_params)
    @kikanmst.save
    respond_with(@kikanmst)
  end

  def update
    @kikanmst.update(kikanmst_params)
    respond_with(@kikanmst)
  end

  def destroy
    @kikanmst.destroy
    respond_with(@kikanmst)
  end
  def ajax
    case params[:focus_field]
      when 'kikan_削除する'
        params[:kikans].each {|kikan_code|
          p kikan_code
          kikan=Kikanmst.find(kikan_code)
          kikan.destroy if kikan
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
      redirect_to kikanmsts_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to kikanmsts_path
    else
      begin
        Kikanmst.transaction do
          Kikanmst.delete_all
          Kikanmst.reset_pk_sequence
          Kikanmst.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to kikanmsts_path
      end
    end
  end

  def export_csv
    @kikanmsts = Kikanmst.all

    respond_to do |format|
      format.html
      format.csv { send_data @kikanmsts.to_csv, filename: "機関マスタ.csv" }
    end
  end  

  def create_modal
    @kikanmst = Kikanmst.new(kikanmst_params)

    respond_to do |format|
      if  @kikanmst.save
        format.js { render 'create_modal'}
      else
        format.js { render json: @kikanmst.errors, status: :unprocessable_entity}
      end
    end
  end

  def update_modal

    @kikanmst = Kikanmst.find(kikanmst_params[:機関コード])

    respond_to do |format|
      if  @kikanmst.update(kikanmst_params)
        format.js { render 'update_modal'}
      else
        format.js { render json: @kikanmst.errors, status: :unprocessable_entity}
      end
    end

  end

  private
    def set_kikanmst
      @kikanmst = Kikanmst.find(params[:id])
    end

    def kikanmst_params
      params.require(:kikanmst).permit(:機関コード, :機関名, :備考 )
    end

    def set_param
      @kikanmst = Kikanmst.new
    end
end
