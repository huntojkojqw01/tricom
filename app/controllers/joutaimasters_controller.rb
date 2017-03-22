class JoutaimastersController < ApplicationController
  before_action :require_user!
  skip_before_action :verify_authenticity_token
  before_action :set_joutaimaster, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv
  respond_to :js

  def index
    @joutaimasters = Joutaimaster.all
  end

  def show

  end

  def new
    @joutaimaster = Joutaimaster.new
  end

  def edit

  end

  def create
    @joutaimaster = Joutaimaster.new(joutaimaster_params)

    flash[:notice] = t "app.flash.new_success" if @joutaimaster.save
    respond_with @joutaimaster

  end

  def update

    flash[:notice] = t "app.flash.update_success" if @joutaimaster.update joutaimaster_params_for_update
    respond_with @joutaimaster

  end

  def destroy
    @joutaimaster.destroy
    respond_with @joutaimaster, location: joutaimasters_url
  end

  def create_joutai
    @joutai = Joutaimaster.new(joutaimaster_params)
    respond_to do |format|
      if  @joutai.save
        format.js { render 'create_joutai'}
      else
        format.js { render json: @joutai.errors, status: :unprocessable_entity}
      end
    end

  end

  def update_joutai
    @joutai = Joutaimaster.find(joutaimaster_params[:状態コード])
    respond_to do |format|
      if  @joutai.update(joutaimaster_params)
        format.js { render 'update_joutai'}
      else
        format.js { render json: @joutai.errors, status: :unprocessable_entity}
      end
    end
  end
  def ajax
    case params[:focus_field]
      when "joutaimaster_削除する"
        params[:joutais].each {|joutai_code|
          joutai = Joutaimaster.find(joutai_code)
          joutai.destroy if joutai
        }
        data = {destroy_success: "success"}
        respond_to do |format|
          format.json { render json: data}
        end
      when 'get_joutai_selected'
        joutai = Joutaimaster.find(params[:joutai_id])
        data = {joutai: joutai}
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to joutaimasters_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to joutaimasters_path
    else
      begin
        Joutaimaster.transaction do
          Joutaimaster.delete_all
          Joutaimaster.reset_pk_sequence
          Joutaimaster.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to joutaimasters_path
      end
    end
  end

  def export_csv
    @joutaimasters = Joutaimaster.all

    respond_to do |format|
      format.html
      format.csv { send_data @joutaimasters.to_csv, filename: "状態マスタ.csv" }
    end
  end
  private

  def joutaimaster_params
    params.require(:joutaimaster).permit(:状態コード, :状態名, :状態区分, :勤怠状態名, :マーク, :色, :text_color, :WEB使用区分, :勤怠使用区分)
  end

  def joutaimaster_params_for_update
    params.require(:joutaimaster).permit(:状態名, :状態区分, :勤怠状態名, :マーク, :色, :text_color, :WEB使用区分, :勤怠使用区分)
  end

  def set_joutaimaster
    @joutaimaster = Joutaimaster.find(params[:id])
  end
end
