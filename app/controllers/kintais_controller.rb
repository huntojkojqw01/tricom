class KintaisController < ApplicationController
  before_action :require_user!
  before_action :set_kintai, only: [:edit, :update, :destroy]
  before_action :check_edit_kintai, only: [:edit]

  respond_to :json, :html

  include UsersHelper

  def index
    begin
      @selected_month = (params[:search] || session[:selected_month]).to_date.strftime("%Y/%m")
    rescue
      @selected_month = Date.today.strftime("%Y/%m")
    end
    session[:selected_month] = @selected_month
    @yuukyuu_kyuuka_rireki = YuukyuuKyuukaRireki.find_or_create_by(社員番号: session[:user], 年月: @selected_month)

    begin_of_month = @selected_month.to_date.beginning_of_month
    check_kintai_at_day_by_user(current_user.id, begin_of_month)
    @kintais = Kintai.selected_month(session[:user], begin_of_month).order(:日付)
    @kintai = Kintai.find_by(日付: begin_of_month, 社員番号: session[:user])

    case params[:commit]
    when (t 'helpers.submit.entered')
      @kintai.update(入力済: '1') if @kintai
      @yuukyuu_kyuuka_rireki.calculate_getshozan     
      @yuukyuu_kyuuka_rireki.calculate_getmatsuzan(@kintais)
      @yuukyuu_kyuuka_rireki.save
    when (t 'helpers.submit.input')
      @kintai.update(入力済: '0') if @kintai
    # when (t 'helpers.submit.create')
    #   check_kintai_at_day_by_user(current_user.id, date)

    when (t 'helpers.submit.destroy')
      if(notice != (t 'app.flash.import_csv'))
        @kintais = Kintai.selected_month(session[:user], begin_of_month).destroy_all
        redirect_to kintais_url
      end
    end # case params[:commit]
    # joutai_array = ['12','15','30','31','32','33','38','103','105','107','109','111','113']
    @joutais = Joutaimaster.where(勤怠使用区分: '1').order('CAST(状態コード AS DECIMAL) asc')
    @daikyus = Kintai.current_user(session[:user]).where(代休取得区分: '0').select(:日付, :id)
  end

  def search
    begin_of_month = (session[:selected_month] || Date.today).to_date.beginning_of_month
    @kintais = Kintai.selected_month(session[:user], begin_of_month)
    @kintais_tonow = Kintai.selected_tocurrent(session[:user], begin_of_month)
    @yukyu = @kintais.day_off.count + @kintais.morning_off.count*0.5 + @kintais.afternoon_off.count*0.5
    if begin_of_month.month == 1
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
        render  pdf: 'kintai_pdf',
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

    # if params[:ignore][:状態1] != ''
    #   byebug
    #   respond_to do |format|
    #     data = {ok: 'ok'}
    #     format.json { respond_with_bip(@kintai) }
    #   end
    # end
    related_kintai ={id: '', joutai: '', bikou: ''}
    related_kintai2 ={id: '', joutai: '', bikou: ''}
    if kintai_params[:状態1].in?(['103','107','111']) #振出
      if kintai_params[:代休取得区分] == ''
        params[:kintai][:代休相手日付] = ''
        params[:kintai][:代休取得区分] = '0'
      #truong hop input truc tiep hoac chuyen tu mot trang thai 振出 khac sang
      else
        if @kintai.状態1 != kintai_params[:状態1]
          if @kintai.代休相手日付 != ''
            furishutsu = Kintai.current_user(session[:user]).find_by(日付: @kintai.代休相手日付)
            if furishutsu
              if furishutsu.代休取得区分 == '1'
                furishutsu.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
              end
              if furishutsu.代休取得区分 == ''
                furishutsu.update(状態1: '', 代休相手日付: '', 備考: '')
              end
              related_kintai[:id] = furishutsu.id
              related_kintai[:joutai] = furishutsu.状態1
              related_kintai[:bikou] = furishutsu.備考
              related_kintai[:joutaimei] = furishutsu.joutai_状態名
            end
          end
          if kintai_params[:代休取得区分].nil?
            params[:kintai][:備考] = ''
          end
          params[:kintai][:代休相手日付] = ''
          params[:kintai][:代休取得区分] = '0'
        end
      end
    elsif kintai_params[:状態1].in?(['105']) #振休
      if kintai_params[:代休相手日付] != ''
        old_furishutsu = Kintai.current_user(session[:user]).find_by(日付: @kintai.代休相手日付)
        if old_furishutsu
          if old_furishutsu.代休取得区分 == '1'
            old_furishutsu.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
          end
          if old_furishutsu.代休取得区分 == ''
            old_furishutsu.update(状態1: '', 代休相手日付: '', 備考: '')
          end
          related_kintai[:id] = old_furishutsu.id
          related_kintai[:joutai] = old_furishutsu.状態1
          related_kintai[:bikou] = old_furishutsu.備考
          related_kintai[:joutaimei] = old_furishutsu.joutai_状態名
        end

        furishutsu = Kintai.current_user(session[:user]).find_by(日付: kintai_params[:代休相手日付])
        furishutsu.update(代休取得区分: '1', 代休相手日付: @kintai.日付, 備考: @kintai.日付.to_s + 'の振出') if furishutsu
        if furishutsu
          related_kintai2[:id] = furishutsu.id
          related_kintai2[:joutai] = furishutsu.状態1
          related_kintai2[:bikou] = furishutsu.備考
          related_kintai2[:joutaimei] = furishutsu.joutai_状態名
        end

      end
    elsif kintai_params[:状態1].in?(['109']) #午前振出
      if kintai_params[:代休相手日付] != ''
        old_furishutsu = Kintai.current_user(session[:user]).find_by(日付: @kintai.代休相手日付)
        if old_furishutsu
          if old_furishutsu.代休取得区分 == '1'
            old_furishutsu.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
          end
          if old_furishutsu.代休取得区分 == ''
            old_furishutsu.update(状態1: '', 代休相手日付: '', 備考: '')
          end
          related_kintai[:id] = old_furishutsu.id
          related_kintai[:joutai] = old_furishutsu.状態1
          related_kintai[:bikou] = old_furishutsu.備考
          related_kintai[:joutaimei] = old_furishutsu.joutai_状態名
        end

        furishutsu = Kintai.current_user(session[:user]).find_by(日付: kintai_params[:代休相手日付])
        furishutsu.update(代休取得区分: '1', 代休相手日付: @kintai.日付, 備考: @kintai.日付.to_s + 'の午前振出') if furishutsu
        if furishutsu
          related_kintai2[:id] = furishutsu.id
          related_kintai2[:joutai] = furishutsu.状態1
          related_kintai2[:bikou] = furishutsu.備考
          related_kintai2[:joutaimei] = furishutsu.joutai_状態名
        end
      end
    elsif kintai_params[:状態1].in?(['113']) #午後振出
      if kintai_params[:代休相手日付] != ''
        old_furishutsu = Kintai.current_user(session[:user]).find_by(日付: @kintai.代休相手日付)
        if old_furishutsu
          if old_furishutsu.代休取得区分 == '1'
            old_furishutsu.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
          end
          if old_furishutsu.代休取得区分 == ''
            old_furishutsu.update(状態1: '', 代休相手日付: '', 備考: '')
          end
          related_kintai[:id] = old_furishutsu.id
          related_kintai[:joutai] = old_furishutsu.状態1
          related_kintai[:bikou] = old_furishutsu.備考
          related_kintai[:joutaimei] = old_furishutsu.joutai_状態名
        end

        furishutsu = Kintai.current_user(session[:user]).find_by(日付: kintai_params[:代休相手日付])
        furishutsu.update(代休取得区分: '1', 代休相手日付: @kintai.日付, 備考: @kintai.日付.to_s + 'の午後振出') if furishutsu
        if furishutsu
          related_kintai2[:id] = furishutsu.id
          related_kintai2[:joutai] = furishutsu.状態1
          related_kintai2[:bikou] = furishutsu.備考
          related_kintai2[:joutaimei] = furishutsu.joutai_状態名
        end
      end
    elsif !kintai_params[:状態1].nil?
      if kintai_params[:代休相手日付].nil?
        if @kintai.代休相手日付 != ''
          furishutsu = Kintai.current_user(session[:user]).find_by(日付: @kintai.代休相手日付)
          if furishutsu
            if furishutsu.代休取得区分 == '1'
              furishutsu.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
            end
            if furishutsu.代休取得区分 == ''
              furishutsu.update(状態1: '', 代休相手日付: '', 備考: '')
            end
            related_kintai[:id] = furishutsu.id
            related_kintai[:joutai] = furishutsu.状態1
            related_kintai[:bikou] = furishutsu.備考
            related_kintai[:joutaimei] = furishutsu.joutai_状態名
          end
        end
        params[:kintai][:備考] = ''
      elsif kintai_params[:代休相手日付] != ''
        furishutsu = Kintai.current_user(session[:user]).find_by(日付: kintai_params[:代休相手日付])
        if furishutsu
          if furishutsu.代休取得区分 == '1'
            furishutsu.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
          end
          if furishutsu.代休取得区分 == ''
            furishutsu.update(状態1: '', 代休相手日付: '', 備考: '')
          end
          related_kintai[:id] = furishutsu.id
          related_kintai[:joutai] = furishutsu.状態1
          related_kintai[:bikou] = furishutsu.備考
          related_kintai[:joutaimei] = furishutsu.joutai_状態名
        end
      end
      params[:kintai][:代休相手日付] = ''
      params[:kintai][:代休取得区分] = ''
    end

    # if kintai_params[:状態1].in?(['105']) #振出
    #   params[:kintai][:代休相手日付] = @kintai.日付
    #   params[:kintai][:代休取得区分] = '0'
    # end
    # if kintai_params[:状態1].in?(['103']) #振休
    #   furishutsu = Kintai.current_user(session[:user]).find_by(代休相手日付: kintai_params[:代休相手日付])
    #   furishutsu.update(代休取得区分: '1', 備考: @kintai.日付.to_s + 'の振出') if furishutsu
    # end

    # flash[:notice] = t 'app.flash.update_success' if @kintai.update(kintai_params)

    respond_to do |format|
      if @kintai.update(kintai_params)
        flash[:notice] = t 'app.flash.update_success'
        current_kintai = {id: @kintai.id, joutai: @kintai.状態1,joutaimei: @kintai.joutai_状態名, bikou: @kintai.備考}
        format.html { redirect_to kintais_url }
        format.json { render :json => {"current_kintai" => current_kintai, "related_kintai" => related_kintai,"related_kintai2" => related_kintai2}}
      else
        format.html { render :action => "edit" }
        format.json { render :json => {"current_kintai" => current_kintai, "related_kintai" => related_kintai,"related_kintai2" => related_kintai2}}
      end
    end
    # respond_with(@kintai, location: kintais_url)
  end


  def ajax
    case params[:id]
      when 'get_kintais'
        if params[:joutai] == '105'
          joutai_aite = '103'
        elsif params[:joutai] == '109'
          joutai_aite = '107'
        elsif params[:joutai] == '113'
          joutai_aite = '111'
        end
        @kintais = Kintai.current_user(session[:user]).where(代休取得区分: '0',状態1: joutai_aite ).select(:日付)
        respond_to do |format|
          # format.json { render json: 'data'}
          format.js { render 'reset_daikyu_modal'}
        end
      when 'update_time'
        time_start = params[:timeStart]
        time_end = params[:timeEnd]
        kintai = Kintai.find_by(id: params[:idKintai])
        kintai.update(出勤時刻: time_start,退社時刻: time_end, 実労働時間: params[:real_hours], 普通残業時間: params[:fustu_zangyo], 深夜残業時間: params[:shinya_zangyou], 深夜保守時間: params[:shinya_kyukei], 遅刻時間: params[:chikoku_soutai])
        data = {update: 'update_success'}
        respond_to do |format|
         format.json { render json: data}
        end
      when 'update_endtime'
        time_end = params[:timeEnd]
        kintai = Kintai.find_by(id: params[:idKintai])
        kintai.update(退社時刻: time_end)
        data = {update: 'update_success'}
        respond_to do |format|
         format.json { render json: data}
        end
      when 'update_starttime'
        time_start = params[:timeStart]
        kintai = Kintai.find_by(id: params[:idKintai])
        kintai.update(出勤時刻: time_start)
        data = {update: 'update_success'}
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
        kintai.update(出勤時刻: starttime, 退社時刻: '', 実労働時間: '', 普通残業時間: '', 深夜残業時間: '', 普通保守時間: '', 深夜保守時間: '', 遅刻時間: '' )
        data = {starttime: text_time,endtime: ''}
        respond_to do |format|
         format.json { render json: data}
        end
      when 'gesshozan_calculate'
        zengetsu = params[:zengetsu]
        tougetsu = params[:tougetsu]
        zan_yuukyu_kyuka = YuukyuuKyuukaRireki.find_by(社員番号: session[:user], 年月: zengetsu)
        tou_yuukyu_kyuka = YuukyuuKyuukaRireki.find_by(社員番号: session[:user], 年月: tougetsu)

        if !zan_yuukyu_kyuka.nil? && !tou_yuukyu_kyuka.nil?
          date = (tougetsu+'/01').to_date
          @kintais = Kintai.selected_month(session[:user], date).order(:日付)
          yukyu = @kintais.day_off.count + @kintais.morning_off.count*0.5 + @kintais.afternoon_off.count*0.5
          getsumatsuzan =  zan_yuukyu_kyuka.月末有給残.to_f- yukyu
          tou_yuukyu_kyuka.update(月初有給残: zan_yuukyu_kyuka.月末有給残.to_f,月末有給残: getsumatsuzan)

        elsif !zan_yuukyu_kyuka.nil? && tou_yuukyu_kyuka.nil?
          date = (tougetsu+'/01').to_date
          @kintais = Kintai.selected_month(session[:user], date).order(:日付)
          yukyu = @kintais.day_off.count + @kintais.morning_off.count*0.5 + @kintais.afternoon_off.count*0.5
          getsumatsuzan =  zan_yuukyu_kyuka.月末有給残.to_f- yukyu
          YuukyuuKyuukaRireki.create(社員番号: session[:user], 年月: tougetsu,月初有給残: zan_yuukyu_kyuka.月末有給残.to_f,月末有給残: getsumatsuzan)

        elsif zan_yuukyu_kyuka.nil? && !tou_yuukyu_kyuka.nil?

          date = (tougetsu+'/01').to_date
          @kintais = Kintai.selected_month(session[:user], date).order(:日付)
          yukyu = @kintais.day_off.count + @kintais.morning_off.count*0.5 + @kintais.afternoon_off.count*0.5
          getsumatsuzan =  tou_yuukyu_kyuka.月初有給残.to_f- yukyu
          tou_yuukyu_kyuka.update(月末有給残: getsumatsuzan)

          date = zengetsu+'/01'
          date = date.to_date
          @kintais = Kintai.selected_month(session[:user], date).order(:日付)
          yukyu = @kintais.day_off.count + @kintais.morning_off.count*0.5 + @kintais.afternoon_off.count*0.5
          gesshozan =  tou_yuukyu_kyuka.月初有給残.to_f+ yukyu

          YuukyuuKyuukaRireki.create(社員番号: session[:user], 年月: zengetsu,月初有給残: gesshozan,月末有給残: tou_yuukyu_kyuka.月初有給残.to_f)

        elsif zan_yuukyu_kyuka.nil? && tou_yuukyu_kyuka.nil?
          yuukyu_kyuka = YuukyuuKyuukaRireki.where(社員番号: session[:user]).order(年月: :desc).first
          first_month = tougetsu[0..3]+'/01'

          if !yuukyu_kyuka.nil?
            if yuukyu_kyuka.年月 >= first_month
              date = yuukyu_kyuka.年月 + '/01'
              senzengetsu = (zengetsu+'/01').to_date.prev_month.end_of_month
              @kintais_to_zengetsu = Kintai.where( 社員番号: session[:user], 日付: date.to_date.next_month.beginning_of_month..senzengetsu)
              yukyu_to_zengetsu = @kintais_to_zengetsu.day_off.count + @kintais_to_zengetsu.morning_off.count*0.5 + @kintais_to_zengetsu.afternoon_off.count*0.5
              gesshozan_zengetsu = yuukyu_kyuka.月末有給残.to_f - yukyu_to_zengetsu
            else
              date = (first_month+'/01').to_date
              senzengetsu = (zengetsu+'/01').to_date.prev_month.end_of_month
              @kintais_to_zengetsu = Kintai.where( 社員番号: session[:user], 日付: date.beginning_of_year..senzengetsu)
              yukyu_to_zengetsu = @kintais_to_zengetsu.day_off.count + @kintais_to_zengetsu.morning_off.count*0.5 + @kintais_to_zengetsu.afternoon_off.count*0.5
              gesshozan_zengetsu = 12 - yukyu_to_zengetsu
            end
          else

            date = (first_month+'/01').to_date
            senzengetsu = (zengetsu+'/01').to_date.prev_month.end_of_month
            @kintais_to_zengetsu = Kintai.where( 社員番号: session[:user], 日付: date.beginning_of_year..senzengetsu)
            yukyu_to_zengetsu = @kintais_to_zengetsu.day_off.count + @kintais_to_zengetsu.morning_off.count*0.5 + @kintais_to_zengetsu.afternoon_off.count*0.5
            gesshozan_zengetsu = 12 - yukyu_to_zengetsu

          end
          date = (zengetsu+'/01').to_date
          @kintais_zengetsu = Kintai.selected_month(session[:user], date).order(:日付)
          yukyu_zengetsu = @kintais_zengetsu.day_off.count + @kintais_zengetsu.morning_off.count*0.5 + @kintais_zengetsu.afternoon_off.count*0.5
          getsumatsu_zengetsu = gesshozan_zengetsu - yukyu_zengetsu
          YuukyuuKyuukaRireki.create(社員番号: session[:user], 年月: zengetsu,月初有給残: gesshozan_zengetsu,月末有給残: getsumatsu_zengetsu)
          date = (tougetsu+'/01').to_date
          @kintais_tougetsu = Kintai.selected_month(session[:user], date).order(:日付)
          yukyu_tougetsu = @kintais_tougetsu.day_off.count + @kintais_tougetsu.morning_off.count*0.5 + @kintais_tougetsu.afternoon_off.count*0.5
          getsumatsu_tougetsu = getsumatsu_zengetsu - yukyu_tougetsu
          YuukyuuKyuukaRireki.create(社員番号: session[:user], 年月: tougetsu,月初有給残: getsumatsu_zengetsu,月末有給残: getsumatsu_tougetsu)
        end
        tou_yuukyu_kyuka = YuukyuuKyuukaRireki.find_by(社員番号: session[:user], 年月: tougetsu)
        data = {gesshozan: tou_yuukyu_kyuka.月初有給残,getsumatsuzan: tou_yuukyu_kyuka.月末有給残}
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
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to kintais_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to kintais_path
    else
      begin
        Kintai.transaction do
          Kintai.delete_all
          Kintai.reset_pk_sequence
          Kintai.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice, param_import: 'test'
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to kintais_path
      end
    end
  end

  def export_csv
    if params[:date]
      begin
        date = params[:date].to_date
      rescue
        date = Date.today
      end
      @results = []
      if params[:tai] == '1'            
        Shainmaster.includes(events: [:joutaimaster, :bashomaster, :jobmaster, :shozokumaster, :kouteimaster])
                  .where(区分: false)
                  .reorder(:序列, :社員番号)
          .each do |shain|
            begin_t, end_t = date.beginning_of_month, date.end_of_month
            events = shain.events.includes(:joutaimaster, :bashomaster, :jobmaster, :shozokumaster, :kouteimaster)
                                .where('Date(開始) <= ? AND Date(終了) >= ? OR Date(開始) <= ? AND Date(終了) >= ? OR Date(開始) >= ? AND Date(終了) <= ?',
                                                  begin_t, begin_t, end_t, end_t, begin_t, end_t)
                                .order(:開始, :終了)

            if events.any?
              events.each do |event|
                @results << {
                  社員番号: shain.社員番号,
                  氏名: shain.氏名,
                  開始: event.開始,
                  終了: event.終了,
                  状態コード: event.状態コード,
                  状態名: event.joutaimaster.try(:状態名),
                  場所コード: event.場所コード,
                  場所名: event.bashomaster.try(:場所名),
                  JOB: event.JOB,
                  JOB名: event.jobmaster.try(:job名),
                  所属コード: event.所属コード,
                  所属名: event.shozokumaster.try(:所属名),
                  工程コード: event.工程コード,
                  工程名: event.kouteimaster.try(:工程名),
                  工数: event.工数,
                  計上: event.計上,
                  comment: event.comment
                }
              end
            else
              @results << {
                  社員番号: shain.社員番号,
                  氏名: shain.氏名,
                  開始: nil,
                  終了: nil,
                  状態コード: nil,
                  状態名: nil,
                  場所コード: nil,
                  場所名: nil,
                  JOB: nil,
                  JOB名: nil,
                  所属コード: nil,
                  所属名: nil,
                  工程コード: nil,
                  工程名: nil,
                  工数: nil,
                  計上: nil,
                  comment: nil
                }
            end # if events.any?
          end # .each do |shain|
      else # if params[:tai] != 1
        Shainmaster.includes(:kintais, :events).where(区分: false).each do |shain|
          kintai = shain.kintais.select { |k| k.日付 == date }
          begin_t, end_t = date.beginning_of_month, date.end_of_month
          events = shain.events.joins(:jobmaster)
                              .where('Date(開始) <= ? AND Date(終了) >= ? OR Date(開始) <= ? AND Date(終了) >= ? OR Date(開始) >= ? AND Date(終了) <= ?',
                               begin_t, begin_t, end_t, end_t, begin_t, end_t)
          if events.any?
            events.select('job名','JOB','SUM(CAST(工数 AS DECIMAL)) AS sum_job').group(:JOB,:job名).order(:JOB).each do |event|
              @results << {
                日付: date.strftime("%Y/%m"),
                氏名: shain.氏名,
                社員番号: shain.社員番号,
                JOB: "#{event.JOB} - #{event.job名}",
                工数: event.sum_job
              }
            end
          else
            @results << {
                日付: date.strftime("%Y/%m"),
                氏名: shain.氏名,
                社員番号: shain.社員番号,
                JOB: nil,
                工数: nil
              }
          end
        end
      end # if params[:tai] != 1
      respond_to do |format|
        format.csv { send_data to_csv_by_date(@results), filename: '勤怠.csv' }
      end
    else
      @kintais = Kintai.all
      respond_to do |format|
        format.html
        format.csv { send_data @kintais.to_csv, filename: '勤怠.csv' }
      end
    end
  end
  def sumikakunin
    begin
      @date = params[:date].to_date
    rescue
      @date = Date.today
    end
    @kintais = Shainmaster.includes(:kintais).where(区分: false).map do |shain|
      kintai = shain.kintais.find { |k| k.日付 == @date }
      {
        氏名: shain.氏名,
        社員番号: shain.社員番号,
        日付: @date,
        入力済: kintai.try(:入力済)        
      }
    end    
  end
  private
    def set_kintai
      @daikyus = Kintai.current_user(session[:user]).where(代休取得区分: '0').select(:日付, :id)
      @kintai = Kintai.find(params[:id])

      kubunlist = []
      case @kintai.曜日
        when '日','土'
          kubunlist = ['1', '2', '5', '6']
        when '月', '火', '水', '木', '金'
          if @kintai.try(:holiday) == '1'
            kubunlist = ['1', '2', '5', '6']
          else
            kubunlist = ['1', '2', '6']
          end
      end
      # @joutais = Joutaimaster.active(kubunlist)
      # joutai_array = ['12','15','30','31','32','33','38','103','105','107','109','111','113']
      @joutais = Joutaimaster.active(kubunlist).order('CAST(状態コード AS DECIMAL) asc')
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

    def to_csv_by_date(datas)
      headers = datas.first.keys
      CSV.generate(headers: true) do |csv|
        csv << headers
        datas.each do |h|
          csv << h.values
        end
      end
    end

end
