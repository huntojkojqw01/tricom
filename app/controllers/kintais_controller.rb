class KintaisController < ApplicationController
  before_action :require_user!
  before_action :set_kintai, only: [:edit, :update, :destroy]
  before_action :check_edit_kintai, only: [:edit]

  respond_to :json, :html

  include UsersHelper

  def index
    @date_now = Date.today.to_date
    @date_param = Date.today
    @date_param = params[:search] if params[:search].present?

    # @date_param = params[:search]
    # @date_param = Date.today.to_date unless date_param.present?

    date = @date_param.to_date
    session[:selected_kintai_date] = date
    check_kintai_at_day_by_user(current_user.id, date)
    case params[:commit]
      when (t 'helpers.submit.entered')
        @kintai = Kintai.find_by(日付: date.beginning_of_month, 社員番号: session[:user])
        @kintai.入力済 = '1' if @kintai
        @kintai.save if @kintai
      when (t 'helpers.submit.input')
        @kintai = Kintai.find_by(日付: date.beginning_of_month, 社員番号: session[:user])
        @kintai.入力済 = '0' if @kintai
        @kintai.save if @kintai
      # when (t 'helpers.submit.create')
      #   check_kintai_at_day_by_user(current_user.id, date)

      when (t 'helpers.submit.destroy')
        if(notice!= (t 'app.flash.import_csv'))
          @kintais = Kintai.selected_month(session[:user], date).order(:日付).destroy_all
        end
    end
    @kintais = Kintai.selected_month(session[:user], date).order(:日付)
    @kintai = Kintai.find_by(日付: date.beginning_of_month, 社員番号: session[:user])
  end

  def search
    @kintais = Kintai.selected_month(session[:user], session[:selected_kintai_date])
    @kintais_tonow = Kintai.selected_tocurrent(session[:user], session[:selected_kintai_date])
    @yukyu = @kintais.day_off.count + @kintais.morning_off.count*0.5 + @kintais.afternoon_off.count*0.5
    if session[:selected_kintai_date].month == 1
      @gesshozan = 12
    else
      @gesshozan = 12 - (@kintais_tonow.day_off.count + @kintais_tonow.morning_off.count*0.5 + @kintais_tonow.afternoon_off.count*0.5)
    end
  end

  def show
    @kintai = Kintai.find_by id: params[:id]
    respond_with(@kintai)
  end
  def pdf_show
    vars = request.query_parameters
    @date_param = Date.today
    @date_param = vars['search'] if vars['search'] != '' && !vars['search'].nil?
    date = @date_param.to_date

    @kintais = Kintai.selected_month(session[:user], date).order(:日付)
    @kintai = Kintai.find_by(日付: date.beginning_of_month, 社員番号: session[:user])
    respond_to do |format|
      format.pdf do
        render  pdf: "kintai_pdf",
                template: 'kintais/pdf_show.pdf.erb',
                encoding: 'utf8',
                orientation: 'Landscape'
      end
    end
  end
  # def new
  #   @kintai = Kintai.new
  #   @kintai.勤務タイプ = Shainmaster.find(session[:user]).勤務タイプ
  #   respond_with(@kintai)
  # end

  def edit
    @kintai = Kintai.find_by id: params[:id]
    if @kintai.勤務タイプ.nil?
      @kintai.勤務タイプ = Shainmaster.find(session[:user]).勤務タイプ
      @kintai.実労働時間 = 8
      @kintai.遅刻時間 = 0
      @kintai.普通残業時間 = 0
      @kintai.深夜残業時間 = 0
      @kintai.普通保守時間 = 0
      @kintai.深夜保守時間 = 0
      date = @kintai.日付.to_s
      case @kintai.勤務タイプ
        when '001'
          @kintai.出勤時刻 = date + ' 07:00:00'
          @kintai.退社時刻 = date + ' 16:00:00'
        when '002'
          @kintai.出勤時刻 = date + ' 07:30:00'
          @kintai.退社時刻 = date + ' 16:30:00'
        when '003'
          @kintai.出勤時刻 = date + ' 08:00:00'
          @kintai.退社時刻 = date + ' 17:00:00'
        when '004'
          @kintai.出勤時刻 = date + ' 08:30:00'
          @kintai.退社時刻 = date + ' 17:30:00'
        when '005'
          @kintai.出勤時刻 = date + ' 09:00:00'
          @kintai.退社時刻 = date + ' 18:00:00'
        when '006'
          @kintai.出勤時刻 = date + ' 09:30:00'
          @kintai.退社時刻 = date + ' 18:30:00'
        when '007'
          @kintai.出勤時刻 = date + ' 10:00:00'
          @kintai.退社時刻 = date + ' 19:00:00'
        when '008'
          @kintai.出勤時刻 = date + ' 10:30:00'
          @kintai.退社時刻 = date + ' 19:30:00'
        when '009'
          @kintai.出勤時刻 = date + ' 11:00:00'
          @kintai.退社時刻 = date + ' 20:00:00'
      end
    end
  end

  # def create
  #   @kintai = Kintai.new(kintai_params)
  #   flash[:notice] = t 'app.flash.new_success' if @kintai.save
  #   respond_with(@kintai, location: kintais_url)
  # end

  def update
    if kintai_params[:状態1].in?(['103']) #振出
      params[:kintai][:代休相手日付] = @kintai.日付
      params[:kintai][:代休取得区分] = '0'
    end
    if kintai_params[:状態1].in?(['105']) #振休
      furishutsu = Kintai.current_month(session[:user]).find_by(代休相手日付: kintai_params[:代休相手日付])
      furishutsu.update(代休取得区分: '1', 備考: @kintai.日付.to_s + 'の振出') if furishutsu
    end

    flash[:notice] = t 'app.flash.update_success' if @kintai.update(kintai_params)
    respond_with(@kintai, location: kintais_url)
  end


  def ajax
    case params[:id]
      when 'update_endtime'
        time_end = params[:timeEnd]
        kintai = Kintai.find_by(id: params[:idKintai])
        kintai.update(退社時刻: time_end)
        data = {update: "update_success"}
        respond_to do |format|
         format.json { render json: data}
        end
      when 'update_starttime'
        time_start = params[:timeStart]
        kintai = Kintai.find_by(id: params[:idKintai])
        kintai.update(出勤時刻: time_start)
        data = {update: "update_success"}
        respond_to do |format|
         format.json { render json: data}
        end
      when 'update_kinmutype'
        kinmutype = params[:kinmutype]
        kintai = Kintai.find_by(id: params[:idKintai])
        date = params[:date]
      case kinmutype
        when '001'
          starttime = date + ' 07:00:00'
          text_time = '07:00'

        when '002'
          starttime = date + ' 07:30:00'
          text_time = '07:30'
        when '003'
          starttime = date + ' 08:00:00'
          text_time = '08:00'
        when '004'
          starttime = date + ' 08:30:00'
          text_time = '08:30'
        when '005'
          starttime = date + ' 09:00:00'
          text_time = '09:00'
        when '006'
          starttime = date + ' 09:30:00'
          text_time = '09:30'
        when '007'
          starttime = date + ' 10:00:00'
          text_time = '10:00'
        when '008'
          starttime = date + ' 10:30:00'
          text_time = '10:30'
        when '009'
          starttime = date + ' 11:00:00'
          text_time = '11:00'
        when ''
          starttime = ''
          text_time = ''
      end
        kintai.update(出勤時刻: starttime, 退社時刻: '' )
        data = {starttime: text_time,endtime: ''}
        respond_to do |format|
         format.json { render json: data}
        end
    end
  end

  def destroy
    flash[:notice] = t 'app.flash.delete_success' if @kintai.destroy
    respond_with(@kintai, location: kintais_url)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to kintais_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to kintais_path
    else
      begin
        Kintai.transaction do
          Kintai.delete_all
          Kintai.reset_pk_sequence
          Kintai.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice, param_import: "test"
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to kintais_path
      end
    end
  end

  def export_csv
    @kintais = Kintai.all

    respond_to do |format|
      format.html
      format.csv { send_data @kintais.to_csv, filename: "勤怠.csv" }
    end
  end

  private
    def set_kintai
      @daikyus = Kintai.current_user(session[:user]).where(代休取得区分: '0').select(:代休相手日付)
      @kintai = Kintai.find(params[:id])

      kubunlist = []
      case @kintai.曜日
        when '日','土'
          kubunlist = ['1','5']
        when '月', '火', '水', '木', '金'
          if @kintai.try(:holiday) == '1'
            kubunlist = ['1','5']
          else
            kubunlist = ['1','2','6']
          end
      end
      @joutais = Joutaimaster.active(kubunlist)
    end

    def kintai_params
      params.require(:kintai).permit(:日付, :曜日, :勤務タイプ, :出勤時刻, :退社時刻, :保守携帯回数, :状態1, :状態2, :状態3, :備考,
        :実労働時間, :遅刻時間, :早退時間, :普通残業時間, :深夜残業時間, :普通保守時間, :深夜保守時間,
        :holiday, :代休相手日付, :代休取得区分)
    end

    def check_edit_kintai
      @kintai_now =Kintai.find_by id: params[:id]
      @kintai = Kintai.find_by(日付: @kintai_now.日付.beginning_of_month, 社員番号: session[:user])
      if @kintai.入力済 == '1'
        flash[:danger] = t 'app.flash.access_denied'
        redirect_to kintais_path
      end
    end
end
