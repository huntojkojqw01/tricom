class KairansController < ApplicationController
  before_action :require_user!
  before_action :set_kairan, only: [:update, :destroy]

  respond_to :json

  include KairansHelper

  def kaitou
    kairan = Kairan.find(params[:id])
    @kairan = Kairan.new(発行者: session[:user], 要件: kairan.要件, 開始: kairan.開始, 終了:kairan.終了, 件名: 'Re:'<< kairan.件名, 内容: 'Re:' << kairan.内容)
    @kaitoid = params[:id]
    @kaitoto = kairan.発行者
    @jushinsha= Shainmaster.find(kairan.発行者).氏名
    @hakkosha = Shainmaster.find(session[:user]).氏名
    @hakkoshaid = session[:user]
    @yoken = Kairanyokenmst.find(kairan.要件).名称
  end

  def kaitou_create
    taiShoSha = params[:kaitoto]
    kairan_params[:発行者] = session[:user]
    kairan = Kairan.create(kairan_params)
    Kairanshosai.create!(回覧コード:kairan.id, 対象者: taiShoSha, 状態: 0)
    kairanShoshai = Kairanshosai.where(回覧コード: params[:kaitoid], 対象者: session[:user]).first!
    kairanShoshai.update(状態: 2)
    update_kairanshosai_counter taiShoSha
    update_kairanshosai_counter session[:user]
    redirect_to kairans_url
  rescue
  end

  def confirm
    strSelected = params[:checked]
    arrSelected = strSelected.split(',') if strSelected
    arrSelected.each do |kairanShoshaiId|
      Kairanshosai.find(kairanShoshaiId).update(状態: 1)
    end
    flash[:notice] = t "app.flash.kairan_confirm"
    redirect_to kairans_url
  end

  def shokairan
    @kairans = Kairan.where(発行者: session[:user])
  end

  def index
    case params[:button]
      when (t 'helpers.button.search')
      when (t 'helpers.button.confirm')
        strSelecteds = params[:checked]
        arrSelecteds = strSelecteds.split(',') if strSelecteds
        arrSelecteds.each do |kairanShoshaiId|
          kairanshosai = Kairanshosai.find(kairanShoshaiId)
          if kairanshosai.状態 == '未確認'
            kairanshosai.update 状態: 1
            # shain = Shainmaster.find kairanshosai.対象者
            # shain = Shainmaster.find session[:user]
            # kairankensu = shain.回覧件数.to_i - 1
            # kairankensu = '' if kairankensu == 0
            # shain.update 回覧件数: kairankensu
          end
        end
        shain = Shainmaster.find session[:user]
        update_kairanshosai_counter shain
        flash[:notice] = t "app.flash.kairan_confirm"
      # redirect_to kairans_url

    end

    @kairanShoshais = Kairanshosai.all
    if params[:head].present?
      @shain_param = params[:head][:shainbango]
    else
      @shain_param = session[:user]
    end
    @yoken = params[:head][:youken] if params[:head].present?
    arrKairanId = Kairan.where(要件: @yoken).ids if @yoken.present?

    @kairanShoshais = @kairanShoshais.where(対象者: @shain_param) if @shain_param.present?
    @kairanShoshais = @kairanShoshais.where(回覧コード: arrKairanId) if @yoken.present?

    old_kairan_process()
    respond_with(@kairanShoshais)

  end

  def show
  end

  def send_kairan_view
    @send_kairan_id = params[:id]
    @kairan = Kairan.find(params[:id])
    @taishosha = Kairanshosai.where(回覧コード: @kairan.id)
    @kairanshosais = @kairan.kairanshosais
    respond_with(@taishosha)
  end

  def new
    @kairan = Kairan.new
    @shains = Shainmaster.all
    respond_with(@kairan)
  end

  def edit
  end

  def create
    # kairan_params[:発行者] = session[:user]
    kairan_params[:状態] = 0
    @kairan = Kairan.new(kairan_params)

    flash[:notice] = t "app.flash.new_success" if @kairan.save
    updateKairanDetail(@kairan.id, params[:shain])
    respond_with(@kairan, location: kairans_url)
  end

  def update
    updateKairanDetail(@kairan.id, params[:shain])
    flash[:notice] = t "app.flash.update_success" if @kairan.update(kairan_params)
    respond_with(@kairan, location: kairans_url)
  end

  def destroy
    @kairanShoshai.destroy
    respond_with(@kairanShoshai, location: kairans_url)
  end

  def export_csv
    @kairans = Kairan.all

    respond_to do |format|
      format.html
      format.csv { send_data @kairans.to_csv, filename: "回覧.csv" }
    end
  end

  private
  def set_kairan
    @kairan = Kairan.find(params[:id])
    @kairanShoshai = Kairanshosai.find(params[:id])
  end

  def kairan_params
    params.require(:kairan).permit(:発行者, :要件, :開始, :終了, :件名, :内容, :確認, :確認要, :確認済)
  end
end
