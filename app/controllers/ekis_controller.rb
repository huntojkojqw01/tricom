class EkisController < ApplicationController
  before_action :require_user!
  before_action :set_eki, only: [:show, :edit, :update, :destroy]
  before_action :eki_params, only: [ :create, :update]
  load_and_authorize_resource except: :export_csv

  respond_to :json, :js

  def index
    @ekis = Eki.all
    respond_with(@ekis)
  end

  def show
    respond_with(@eki)
  end

  def new
    @eki = Eki.new
    respond_with(@eki)
  end

  def edit   
  end

  def create
    @eki = Eki.new(eki_params)
    flash[:notice] = t 'app.flash.new_success' if @eki.save
    respond_with(@eki)
  end

  def update
    flash[:notice] = t 'app.flash.update_success' if @eki.update(eki_params)
    respond_with(@eki)
  end

  def destroy    
    @eki.destroy    
    respond_with(@eki)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to ekis_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to ekis_path
    else
      begin
        Eki.transaction do
          Eki.delete_all
          Eki.reset_pk_sequence
          Eki.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to ekis_path
      end
    end
  end

  def export_csv
    @ekis = Eki.all

    respond_to do |format|
      format.html
      format.csv { send_data @ekis.to_csv, filename: '駅マスタ.csv' }
    end
  end

  def ajax
    case params[:focus_field]
      when 'eki_削除する'
        params[:ekis].each{ |ekiId|
          eki=Eki.find_by(駅コード: ekiId)
          eki.destroy if eki
        }

        data = {destroy_success: 'success'}
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end

  def create_eki
    @eki = Eki.new(eki_params)

    respond_to do |format|
      if  @eki.save
        format.js { render 'create_eki'}
      else
        format.js { render json: @eki.errors, status: :unprocessable_entity}
      end
    end
  end

  def update_eki
    @eki = Eki.find(eki_params[:駅コード])

    respond_to do |format|
      if  @eki.update(eki_params)
        format.js { render 'edit_eki'}
      else
        format.js { render json: @eki.errors, status: :unprocessable_entity}
      end
    end

  end

  private
    def set_eki
      @eki = Eki.find(params[:id])
    end
    def eki_params
      params.require(:eki).permit(:駅コード, :駅名, :駅名カナ)
    end
end
