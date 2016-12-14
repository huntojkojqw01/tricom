class DengonyoukensController < ApplicationController
  before_action :require_user!
  before_action :set_dengonyouken, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dengonyoukens = Dengonyouken.all
    respond_with(@dengonyoukens)
  end

  def show
    respond_with(@dengonyouken)
  end

  def new
    @dengonyouken = Dengonyouken.new
    respond_with(@dengonyouken)
  end

  def edit
  end

  def create
    @dengonyouken = Dengonyouken.new(dengonyouken_params)
    @dengonyouken.save
    respond_with(@dengonyouken, location: dengonyoukens_url)
  end

  def update
    @dengonyouken.update(dengonyouken_params)
    respond_with(@dengonyouken, location: dengonyoukens_url)
  end

  def destroy
    @dengonyouken.destroy
    respond_with(@dengonyouken)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to dengonyoukens_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to dengonyoukens_path
    else
      begin
        Dengonyouken.transaction do
          Dengonyouken.delete_all
          Dengonyouken.reset_pk_sequence
          Dengonyouken.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to dengonyoukens_path
      end
    end
  end

  def export_csv
    @dengonyoukens = Dengonyouken.all

    respond_to do |format|
      format.html
      format.csv { send_data @dengonyoukens.to_csv, filename: "伝言用件マスタ.csv" }
    end
  end

  private
    def set_dengonyouken
      @dengonyouken = Dengonyouken.find(params[:id])
    end

    def dengonyouken_params
      params.require(:dengonyouken).permit(:種類名, :備考, :優先さ)
    end
end
