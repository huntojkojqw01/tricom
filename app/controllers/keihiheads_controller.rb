class KeihiheadsController < ApplicationController
  before_action :require_user!
  before_action :set_keihi, only: [:show, :edit, :update, :destroy]
  before_action :set_modal, only: [:new, :edit, :update, :destroy, :create, :update]
  # load_and_authorize_resource

  respond_to :js

  def index
    @keihiheads = Keihihead.current_member(session[:user]).order(申請番号: :desc)
  end

  def show
  end

  def new
    @keihi = Keihihead.new(日付: Date.today)
    shinsheino = 1
    # shinsheino = Keihihead.maximum(:id) + 1 if Keihihead.exists?
    shinsheino = Keihihead.pluck(:id).map {|i| i.to_i}.max + 1 if Keihihead.exists?

    # shinsheino = Keihihead.order(id: :desc).first.id.to_i + 1 if Keihihead.exists?
    @keihi.id = shinsheino.to_s
    @keihi.keihibodies.build

    respond_with(@keihi)
  end

  def edit
    # @keihi.keihibodies.build
  end

  def create
    # case params[:commit]
    #   when '経費データ検索'
    #     begin
    #       @keihi = Keihihead.find keihi_params[:申請番号]
    #       if @keihi.承認kubun == '1'
    #         redirect_to keihihead_url(@keihi)
    #       else
    #         redirect_to edit_keihihead_url(@keihi)
    #       end
    #     rescue ActiveRecord::RecordNotFound
    #       flash[:warning] = t "app.flash.record_not_found"
    #       redirect_to :back
    #       return
    #     end
    #
    #   when '登　録'
    #     params[:keihihead][:日付] = Date.today if keihi_params[:日付].blank?
    #     @keihi = Keihihead.new(keihi_params)
    #     flash[:notice] = t 'app.flash.new_success' if @keihi.save
    #     # respond_with(@keihi, location: keihis_url)
    #     redirect_to new_keihihead_url
    # end

    params[:keihihead][:日付] = Date.today if keihi_params[:日付].blank?
    @keihi = Keihihead.new(keihi_params)
    @keihi.id = 1
    @keihi.id = Keihihead.pluck(:id).map {|i| i.to_i}.max + 1 if Keihihead.exists?
    @keihi.社員番号 = session[:user]
    if @keihi.save
      flash[:notice] = t 'app.flash.new_success'
      redirect_to keihiheads_url
    else
      flash[:danger] = t 'app.flash.unsucess'
      render :new
    end
  end

  def update
    case params[:commit]
      when '登録する'
        params[:keihihead][:日付] = Date.today if keihi_params[:日付].nil?
        if @keihi.update(keihi_params)
          flash[:notice] = t "app.flash.update_success"
          redirect_to keihiheads_url

        else
          flash[:danger] = t 'app.flash.unsucess'
          render :edit

        end
      when '削除する'
        flash[:notice] = t "app.flash.delete_success" if @keihi.destroy
        respond_with @keihi, location: keihiheads_url
    end
  end

  def destroy
    @keihi.destroy
    respond_with(@keihi, location: keihiheads_url)
  end

  def ajax
    case params[:id]
      when 'getshinshei'
        date = params[:date]
        listshinshei = Keihihead.current_member(session[:user]).order(updated_at: :desc).pluck(:申請番号)
        listshinshei = Keihihead.current_member(session[:user]).where(日付: date).pluck(:申請番号) if !date.blank?
        data = {listshinshei: listshinshei}
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end

  def shonin_search
    @keihi_shonins = Keihihead.where(承認者: session[:user]).where("承認済区分 != ? or 承認済区分 is null", '1')
    @keihi_shonins = @keihi_shonins.where("Date(清算予定日) <= ?", params[:清算予定日]) if params[:清算予定日]

    if params[:commit] == '更新する' && !params[:shonin].nil?
      flash[:notice] = t 'app.flash.update_success' if Keihihead.where(id: params[:shonin]).update_all(承認済区分: '1')
    end
  end

  def export_csv
    @keihiheads = Keihihead.all

    respond_to do |format|
      format.html
      format.csv { send_data @keihiheads.to_csv, filename: "経費ヘッド.csv" }
    end
  end

  private
  def set_keihi
    @keihi = Keihihead.find(params[:id])
  end

  def set_modal
    @kaishamasters = Kaishamaster.all
    @kikans = Kikanmst.all
    @ekis = Eki.all
    # @shonins = Shoninshamst.current_user(session[:user])
    # @shonins = Shoninshamst.all
    @shonins = Shoninshamst.where(申請者: session[:user])
    @jobs = Jobmaster.all
  end

  def keihi_params
    params.require(:keihihead).permit(:申請番号, :日付, :社員番号, :申請者, :交通費合計, :日当合計, :宿泊費合計, :その他合計,
      :旅費合計, :仮払金, :合計, :支給品, :過不足, :承認kubun, :承認者, :清算予定日, :清算日, :承認済区分,
      keihibodies_attributes: [:id, :申請番号, :日付, :社員番号, :相手先, :機関名,
        :発, :着, :発着kubun, :交通費, :日当, :宿泊費, :その他, :JOB,
        :備考, :領収書kubun, :_destroy])
  end
end
