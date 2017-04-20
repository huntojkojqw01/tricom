class SetsubiyoyakusController < ApplicationController
  before_action :require_user!
  before_action :set_setsubiyoyaku, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index

    @hizukes = all_day_in_month_list()
    @all_events = Event.all
    @shains = Shainmaster.all
    @setsubiyoyaku = Setsubiyoyaku.all
    if params[:head].present?
      @setsubi_param = params[:head][:setsubicode]
    end
    @setsubiyoyaku = Setsubiyoyaku.where(設備コード: @setsubi_param) if @setsubi_param.present?
    respond_with(@setsubiyoyaku)
  end

  def all_day_in_month_list()
    d = Date.today
    (d.at_beginning_of_month.to_date..d.at_end_of_month.to_date)
  end

  def show
    respond_with(@setsubiyoyaku)
  end

  def new
    @kaishamasters = Kaishamaster.all
    vars = request.query_parameters
    param_date = vars['start_at']
    param_setsubi = vars['setsubi_code']
    param_allday = vars['all_day']
    if(param_date.nil?)
      date = Date.today.to_s(:db)
    else
      date = param_date
    end

    if(param_setsubi.nil?)
      setsubi = Setsubi.all.first.設備コード
    else
      setsubi = param_setsubi
    end

    if param_allday == "true"
      @setsubiyoyaku = Setsubiyoyaku.new(予約者: session[:user],設備コード: setsubi,開始: "#{date} 00:00", 終了: "#{date} 24:00")
    else
      @setsubiyoyaku = Setsubiyoyaku.new(予約者: session[:user],設備コード: setsubi,開始: "#{date} 09:00", 終了: "#{date} 18:00")
    end



    # if(!param_date.nil?)
    #   @setsubiyoyaku = Setsubiyoyaku.new(開始: "#{param_date} 09:00", 終了: "#{param_date} 18:00")
    # else
    #   @setsubiyoyaku = Setsubiyoyaku.new(開始: "#{date} 09:00", 終了: "#{date} 18:00")
    # end
    respond_with(@setsubiyoyaku)
  end

  def edit
    @kaishamasters = Kaishamaster.all
  end

  def create
    @kaishamasters = Kaishamaster.all
    @setsubiyoyaku = Setsubiyoyaku.new setsubiyoyaku_params
    @setsubiyoyaku.save
    respond_with @setsubiyoyaku, location: setsubiyoyakus_url(:head => {setsubicode: @setsubiyoyaku.設備コード})
  end

  def update
    # setsubiyoyaku_params['設備コーchanged']=false
    # setsubiyoyaku_params.add('設備コーchanged'=>'false')
    # byebug
    # if @setsubiyoyaku.設備コード == setsubiyoyaku_params.設備コード
        # setsubiyoyaku_params.add('設備コーchanged'=>'true')
        # setsubiyoyaku_params['設備コーchanged']=true
    # end
    if @setsubiyoyaku.update_attributes(setsubiyoyaku_params)
      flash[:notice] = t "app.flash.update_success"
      redirect_to setsubiyoyakus_url(:head => {setsubicode: @setsubiyoyaku.設備コード})
    else
      @kaishamasters = Kaishamaster.all
      render :edit
      # respond_with(@setsubiyoyaku)
    end
  end

  def destroy
    setsubicode = @setsubiyoyaku.設備コード
    @setsubiyoyaku.destroy
    respond_with @setsubiyoyaku, location: setsubiyoyakus_url(:head => {setsubicode: setsubicode})
    end

  def ajax
    case params[:focus_field]
      when "setsubiyoyaku_相手先"
        kaisha_name = Kaishamaster.find_by(code: params[:kaisha_code]).try :name
        data = {kaisha_name: kaisha_name}
        respond_to do |format|
          format.json { render json: data}
        end
      when "setsubiyoyaku_update"
        setsubiyoyaku = Setsubiyoyaku.find(params[:eventId])
        setsubiyoyaku.update(開始: params[:event_start], 終了: params[:event_end])
        data = {setsubiyoyaku: setsubiyoyaku.id}
        respond_to do |format|
          format.json { render json: data}
        end
      when 'setsubiyoyaku_削除する'
        setsubiyoyakuIds = params[:setsubiyoyakus]
        setsubiyoyakuIds.each{ |setsubiyoyakuId|
          Setsubiyoyaku.find_by(id: setsubiyoyakuId).destroy
        }
        data = {destroy_success: "success"}
        respond_to do |format|
        format.json { render json: data}
      end
    end
  end
  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to setsubiyoyakus_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to setsubiyoyakus_path
    else
      begin
        Setsubiyoyaku.transaction do
          Setsubiyoyaku.delete_all
          Setsubiyoyaku.reset_pk_sequence
          Setsubiyoyaku.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to setsubiyoyakus_path
      end
    end
  end

  def export_csv
    @setsubiyoyakus = Setsubiyoyaku.all

    respond_to do |format|
      format.html
      format.csv { send_data @setsubiyoyakus.to_csv, filename: "設備予約.csv" }
    end
  end
  private
  def set_setsubiyoyaku
    @setsubiyoyaku = Setsubiyoyaku.find(params[:id])
  end

  def setsubiyoyaku_params
    params.require(:setsubiyoyaku).permit(:設備コード, :予約者, :相手先, :開始, :終了, :用件)
  end
end
