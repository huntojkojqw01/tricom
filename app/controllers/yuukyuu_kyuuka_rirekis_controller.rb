class YuukyuuKyuukaRirekisController < ApplicationController
  before_action :set_yuukyuu_kyuuka_rireki, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  def new
    @yuukyuu_kyuuka_rireki = YuukyuuKyuukaRireki.new
    respond_with(@yuukyuu_kyuuka_rireki)
  end

  def index
    @yuukyuu_kyuuka_rireki = YuukyuuKyuukaRireki.all
  end

  def show
    respond_with(@yuukyuu_kyuuka_rireki)
  end

  def edit
    respond_with(@yuukyuu_kyuuka_rireki)
  end

  def create
    @yuukyuu_kyuuka_rireki = YuukyuuKyuukaRireki.new(yuukyuu_kyuuka_rireki_params)
    flash[:notice] = t 'app.flash.new_success' if @yuukyuu_kyuuka_rireki.save
    respond_with(@yuukyuu_kyuuka_rireki, location: yuukyuu_kyuuka_rirekis_url)
  end

  def update
    flash[:notice] = t 'app.flash.update_success' if @yuukyuu_kyuuka_rireki.update(yuukyuu_kyuuka_rireki_params)
    respond_with(@yuukyuu_kyuuka_rireki, location: yuukyuu_kyuuka_rirekis_url)
  end

  def destroy

    @yuukyuu_kyuuka_rireki.destroy
    respond_with(@yuukyuu_kyuuka_rireki)
  end
  def ajax
    case params[:focus_field]     
      when 'ykkkre_削除する'
        ykkkreIds = params[:ykkkres]
        ykkkreIds.each{ |ykkkreId|
          YuukyuuKyuukaRireki.find(ykkkreId).destroy          
        }        
        data = {destroy_success: 'success'}
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end
  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to yuukyuu_kyuuka_rirekis_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to yuukyuu_kyuuka_rirekis_path
    else
      begin
        YuukyuuKyuukaRireki.transaction do
          YuukyuuKyuukaRireki.delete_all
          YuukyuuKyuukaRireki.reset_pk_sequence
          YuukyuuKyuukaRireki.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to yuukyuu_kyuuka_rirekis_path
      end
    end
  end

  def export_csv
    @yuukyuu_kyuuka_rirekis = YuukyuuKyuukaRireki.all
    respond_to do |format|
      format.html
      format.csv { send_data @yuukyuu_kyuuka_rirekis.to_csv, filename: '有給休暇履歴.csv' }
    end
  end

  private
    def set_yuukyuu_kyuuka_rireki
      params[:id].try(:gsub!, '-', '/')
      @yuukyuu_kyuuka_rireki = YuukyuuKyuukaRireki.find_by(id: params[:id])
    end

    def yuukyuu_kyuuka_rireki_params
      params.require(:yuukyuu_kyuuka_rireki).permit :年月, :社員番号, :月初有給残, :月末有給残
    end
end
