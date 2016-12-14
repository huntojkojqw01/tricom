class DengonkaitousController < ApplicationController
  before_action :require_user!
  before_action :set_dengonkaitou, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dengonkaitous = Dengonkaitou.all
    respond_with(@dengonkaitous)
  end

  def show
    respond_with(@dengonkaitou)
  end

  def new
    @dengonkaitou = Dengonkaitou.new
    respond_with(@dengonkaitou)
  end

  def edit
  end

  def create
    @dengonkaitou = Dengonkaitou.new(dengonkaitou_params)
    @dengonkaitou.save
    respond_with(@dengonkaitou, location: dengonkaitous_url)
  end

  def update
    @dengonkaitou.update(dengonkaitou_params)
    respond_with(@dengonkaitou, location: dengonkaitous_url)
  end

  def destroy
    @dengonkaitou.destroy
    respond_with(@dengonkaitou)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to dengonkaitous_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to dengonkaitous_path
    else
      begin
        Dengonkaitou.transaction do
          Dengonkaitou.delete_all
          Dengonkaitou.reset_pk_sequence
          Dengonkaitou.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to dengonkaitous_path
      end
    end
  end

  def export_csv
    @dengonkaitous = Dengonkaitou.all

    respond_to do |format|
      format.html
      format.csv { send_data @dengonkaitous.to_csv, filename: "伝言回答マスタ.csv" }
    end
  end

  private
    def set_dengonkaitou
      @dengonkaitou = Dengonkaitou.find(params[:id])
    end

    def dengonkaitou_params
      params.require(:dengonkaitou).permit(:種類名, :備考)
    end
end
