class ShozokumastersController < ApplicationController
  before_action :require_user!
  skip_before_action :verify_authenticity_token
  before_action :set_param, only: :index
  load_and_authorize_resource except: :export_csv
  respond_to :js

  def index
  end

  def show
  end

  def new
  end

  def edit

  end

  def create
    flash[:notice] = t "app.flash.new_success" if @shozokumaster.save
    respond_with @shozokumaster

  end

  def update
    flash[:notice] = t "app.flash.update_success" if @shozokumaster.
      update_attributes shozokumaster_params
    respond_with @shozokumaster
  end

  def destroy
    @shozokumaster.destroy
    respond_with @shozokumaster, location: shozokumasters_url
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to shozokumasters_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to shozokumasters_path
    else
      begin
        Shozokumaster.transaction do
          Shozokumaster.delete_all
          Shozokumaster.reset_pk_sequence
          Shozokumaster.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to shozokumasters_path
      end
    end
  end

  def export_csv
    @shozokumasters = Shozokumaster.all

    respond_to do |format|
      format.html
      format.csv { send_data @shozokumasters.to_csv, filename: "所属マスタ.csv" }
    end
  end

   def ajax
    case params[:focus_field]
      when 'shozoku_削除する'
        shozoku = Shozokumaster.find(params[:shozoku_id]).destroy
        data = {destroy_success: "success"}
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end

  def create_shozoku
    @shozokumaster = Shozokumaster.new(shozokumaster_params)

    respond_to do |format|
      if  @shozokumaster.save
        format.js { render 'create_shozoku'}
      else
        format.js { render json: @shozokumaster.errors, status: :unprocessable_entity}
      end
    end
  end

  def update_shozoku
    @shozokumaster = Shozokumaster.find(shozokumaster_params[:所属コード])

    respond_to do |format|
      if  @shozokumaster.update(shozokumaster_params)
        format.js { render 'update_shozoku'}
      else
        format.js { render json: @shozokumaster.errors, status: :unprocessable_entity}
      end
    end

  end



  private
    def shozokumaster_params
      params.require(:shozokumaster).permit :所属コード, :所属名
    end
    def set_param
      @shozokumaster = Shozokumaster.new
    end
end
