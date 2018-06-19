class YuusensController < ApplicationController
  before_action :require_user!
  before_action :set_yuusen, only: [:show, :edit, :update]
  load_and_authorize_resource except: [:export_csv, :destroy]
  respond_to :html, :js

  def index
    @yuusens = Yuusen.all
    respond_with(@yuusens)
  end

  def show
    respond_with(@yuusen)
  end

  def new
    @yuusen = Yuusen.new
    respond_with(@yuusen)
  end

  def edit
  end

  def create
    @yuusen = Yuusen.new(yuusen_params)
    flash[:notice] = t 'app.flash.new_success' if @yuusen.save
    respond_with(@yuusen, location: yuusens_url)

  end

  def update
    flash[:nitice] = t 'app.flash.update_success' if @yuusen.update(yuusen_params)
    respond_with(@yuusen, location: yuusens_url)
  end

  def destroy
    if params[:ids]
      Yuusen.where(id: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @yuusen = Yuusen.find_by_id(params[:id])
      @yuusen.destroy if @yuusen
      respond_with(@yuusen, location: yuusens_url)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to yuusens_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to yuusens_path
    else
      begin
        Yuusen.transaction do
          Yuusen.delete_all
          Yuusen.reset_pk_sequence
          Yuusen.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to yuusens_path
      end
    end
  end

  def ajax
    case params[:focus_field]
      when 'yuusen_削除する'
        yuusenIds = params[:yuusens]
        yuusenIds.each{ |yuusenId|
          Yuusen.find_by(優先さ: yuusenId).destroy
        }
        data = {destroy_success: 'success'}
        respond_to do |format|
        format.json { render json: data}
      end
    end
  end

  def export_csv
    @yuusens = Yuusen.all

    respond_to do |format|
      format.html
      format.csv { send_data @yuusens.to_csv, filename: '優先.csv' }
    end
  end

  private
    def set_yuusen
      @yuusen = Yuusen.find(params[:id])
    end

    def yuusen_params
      params.require(:yuusen).permit(:優先さ, :備考, :色)
    end
end
