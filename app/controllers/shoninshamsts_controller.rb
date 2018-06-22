class ShoninshamstsController < ApplicationController
  before_action :require_user!
  before_action :set_shoninshamst, only: [:show, :edit, :update]
  load_and_authorize_resource except: [:export_csv, :destroy]

  respond_to :html, :js

  def index
    @shoninshamsts = Shoninshamst.all
    respond_with(@shoninshamsts)
  end

  def show
    respond_with(@shoninshamst)
  end

  def new
    @shoninshamst = Shoninshamst.new
    respond_with(@shoninshamst)
  end

  def edit
  end

  def create
    @shoninshamst = Shoninshamst.new(shoninshamst_params)
    if @shoninshamst.save
      flash[:notice] = t 'app.flash.update_success'
    respond_with(@shoninshamst, location: shoninshamsts_url)
    else
      render :new
    end
  end

  def update
    @shoninshamst.update(shoninshamst_params)
    respond_with(@shoninshamst, location: shoninshamsts_url)
  end

  def destroy
    if params[:ids]
      Shoninshamst.where(id: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @shoninshamst = Shoninshamst.find_by_id(params[:id])
      @shoninshamst.destroy if @shoninshamst
      respond_with(@shoninshamst)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to shoninshamsts_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to shoninshamsts_path
    else
      begin
        Shoninshamst.transaction do
          Shoninshamst.delete_all
          Shoninshamst.reset_pk_sequence
          Shoninshamst.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to shoninshamsts_path
      end
    end
  end

  def export_csv
    @shoninshamsts = Shoninshamst.all

    respond_to do |format|
      format.html
      format.csv { send_data @shoninshamsts.to_csv, filename: '承認者マスタ.csv' }
    end
  end

  def ajax
    case params[:focus_field]
      when 'shonin_削除する'
        shoninIds = params[:shonins]
        shoninIds.each{ |shoninId|
          Shoninshamst.find_by(id: shoninId).destroy
        }
        data = {destroy_success: 'success'}
        respond_to do |format|
        format.json { render json: data}
      end
    end
  end

  def create_shonin
    @shoninshamst = Shoninshamst.new(shoninshamst_params)
    respond_to do |format|
      if  @shoninshamst.save
        format.js { render 'create_shoninsha'}
      else
        format.js { render json: @shoninshamst.errors, status: :unprocessable_entity}
      end
    end
    end

  
  private
    def set_shoninshamst
      @shoninshamst = Shoninshamst.find(params[:id])
    end

    def shoninshamst_params
      params.require(:shoninshamst).permit(:id, :申請者, :承認者, :順番)
    end
end
