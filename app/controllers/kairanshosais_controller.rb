class KairanshosaisController < ApplicationController
  before_action :require_user!
  before_action :set_kairanshosai, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  respond_to :html
  def export_csv
    @kairanshosais = Kairanshosai.all

    respond_to do |format|
      format.html
      format.csv { send_data @kairanshosais.to_csv, filename: "回覧詳細.csv" }
    end
  end

  private
    def set_kairanshosai
      @kairanshosai = Kairanshosai.find(params[:id])
    end

    def kairanshosai_params
      params.require(:kairanshosai).permit(:回覧コード, :対象者, :created_at, :updated_at, :状態)
    end





end