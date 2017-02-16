class EventsController < ApplicationController
  before_action :require_user!
  before_action :set_event, only: [ :show, :edit, :update, :destroy]
  before_action :set_param, only: [ :create, :new, :show, :edit, :update, :destroy]
  # load_and_authorize_resource
  respond_to :json

  include EventsHelper

  def index
    @all_events = Event.where("Date(開始) = ?", Date.today.to_s(:db))
    @shains = Shainmaster.order(:所属コード, :役職コード, :社員番号).all
    @holidays = JptHolidayMst.all
    session[:selected_shain] = current_user.id unless session[:selected_shain].present?
    @events = Shainmaster.find(session[:selected_shain]).events.
      where("Date(開始) >= ?",(Date.today - 1.month).to_s(:db)).
      order(開始: :desc)
    @shain = Shainmaster.find(session[:selected_shain])
    @kairanCount = Kairanshosai.where(対象者: session[:user], 状態: 0).count
    shain = Shainmaster.find(session[:user])
    if shain
      shain.回覧件数 = @kairanCount
      shain.save
    end
    @kintai = Kintai.first

  rescue
    @events = Shainmaster.take.events
    # 不在状態の社員
    # check_user_status()

    # @shain_names = @shains.select :id, :title
    # respond_with(@shain_names) do |format|
    #   format.json {
    #     render json: {
    #                :shains => @shain_names,
    #                :events => @events
    #            }}
    # end
  end

  def pdf_event_show
    vars = request.query_parameters
    @date_start = vars['date_start'] if vars['date_start'] != '' && !vars['date_start'].nil?
    @date_end = vars['date_end'] if vars['date_end'] != '' && !vars['date_end'].nil?


    session[:selected_shain] = current_user.id unless session[:selected_shain].present?
    @events = Shainmaster.find(session[:selected_shain]).events.
      where("Date(開始) >= ?",@date_start.to_date.to_s(:db)).
      where("Date(終了) <= ?",@date_end.to_date.to_s(:db)).
      order(開始: :asc)
    @events.each{ |event|
        Event.find_by(id: event.id).update(工数: get_koushuu(event.開始, event.終了))
    }
    @shain = Shainmaster.find(session[:selected_shain])
    date = @date_start.to_date
    respond_to do |format|
      format.pdf do
        render  pdf: "event_pdf",
                template: 'events/pdf_show.pdf.erb',
                encoding: 'utf8',
                orientation: 'Landscape',
                title: (t 'app.label.pdf_event')
      end
    end
  end

   def pdf_job_show
    vars = request.query_parameters
    @date_start = vars['date_start'] if vars['date_start'] != '' && !vars['date_start'].nil?
    @date_end = vars['date_end'] if vars['date_end'] != '' && !vars['date_end'].nil?


    session[:selected_shain] = current_user.id unless session[:selected_shain].present?
    @events = Shainmaster.find(session[:selected_shain]).events.
      where("Date(開始) >= ?",@date_start.to_date.to_s(:db)).
      where("Date(終了) <= ?",@date_end.to_date.to_s(:db))
    @events.each{ |event|
        Event.find_by(id: event.id).update(工数: get_koushuu(event.開始, event.終了))
    }
    # 'JOB, 工数'
    @eventJOB = @events.select('JOB','SUM(CAST(工数 AS DECIMAL)) AS sum_job').group(:JOB).order(:JOB)
    # @problems = @test.select('JOB','工数').group(:JOB).order(:JOB).sum("CAST(events.工数 AS DECIMAL)")
     # te = Kintai.select("勤務タイプ","SUM(実労働時間) AS KKK").group(:勤務タイプ).order(:勤務タイプ => :asc)
    @shain = Shainmaster.find(session[:selected_shain])
    date = @date_start.to_date
    respond_to do |format|
      format.pdf do
        render  pdf: "event_job_pdf",
                title: (t 'app.label.pdf_event_job'),
                template: 'events/pdf_job_show.pdf.erb',
                encoding: 'utf8',
                orientation: 'Landscape'
      end
    end
  end

   def pdf_koutei_show
    vars = request.query_parameters
    @date_start = vars['date_start'] if vars['date_start'] != '' && !vars['date_start'].nil?
    @date_end = vars['date_end'] if vars['date_end'] != '' && !vars['date_end'].nil?


    session[:selected_shain] = current_user.id unless session[:selected_shain].present?
    @events = Shainmaster.find(session[:selected_shain]).events.
      where("Date(開始) >= ?",@date_start.to_date.to_s(:db)).
      where("Date(終了) <= ?",@date_end.to_date.to_s(:db))
    @events.each{ |event|
        Event.find_by(id: event.id).update(工数: get_koushuu(event.開始, event.終了))
    }
    # 'JOB, 工数'
    @eventKoutei = @events.select('JOB','工程コード','SUM(CAST(工数 AS DECIMAL)) AS sum_job').group(:JOB,:工程コード).order(:JOB)
    # @problems = @test.select('JOB','工数').group(:JOB).order(:JOB).sum("CAST(events.工数 AS DECIMAL)")
     # te = Kintai.select("勤務タイプ","SUM(実労働時間) AS KKK").group(:勤務タイプ).order(:勤務タイプ => :asc)
    @shain = Shainmaster.find(session[:selected_shain])
    date = @date_start.to_date
    respond_to do |format|
      format.pdf do
        render  pdf: "event_koutei_pdf",
                title: (t 'app.label.pdf_event_koutei'),
                template: 'events/pdf_koutei_show.pdf.erb',
                encoding: 'utf8',
                orientation: 'Landscape'
      end
    end
  end

  def time_line_view

    @role = Rorumaster.all
    @joutai = Joutaimaster.all
    @roru = Shainmaster.find(session[:user]).rorumaster
    @setting = Setting.where(社員番号: session[:user]).first
    if request.post?
      case params[:commit]
        when (t 'helpers.submit.redirect_to_timeline')
          redirect_to time_line_view_events_url
        when (t 'helpers.submit.redirect_to_kintai')
          redirect_to kintais_url
        when (t 'helpers.submit.redirect_to_keihihead')
          redirect_to keihiheads_url
        when (t 'helpers.submit.redirect_to_dengon')
          redirect_to dengons_url
        when (t 'helpers.submit.redirect_to_shonin')
          redirect_to shonin_search_keihiheads_url
        when (t 'helpers.submit.redirect_to_kairan')
          redirect_to kairans_url
        when (t 'helpers.submit.redirect_to_setsubiyoyaku')
          redirect_to setsubiyoyakus_url
      end
    else
      vars = request.query_parameters
      @all_events = Event.all
      @shains = Shainmaster.where(タイムライン区分: false).all
      if vars['roru'].empty? && vars['joutai'].empty?
        @all_events = Event.all
        @shains = Shainmaster.joins(:rorumenbas).where(タイムライン区分: false).reorder("ロールメンバ.ロール内序列 asc,ロールメンバ.ロールコード asc")
      else
        if !vars['roru'].empty? && vars['joutai'].empty?
          rorumenbas = Rorumenba.where(ロールコード: vars['roru'])
          @shains = Shainmaster.where(タイムライン区分: false).joins(:rorumenbas).where(ロールメンバ: {ロールコード: vars['roru']}).reorder('ロールメンバ.ロールコード asc,ロールメンバ.ロール内序列 asc')
          @all_event=Event.all
        end
        if vars['roru'].empty? && !vars['joutai'].empty?
          @all_events=Event.where(状態コード: vars['joutai'])
          @shains = Shainmaster.where(タイムライン区分: false).all.joins(:rorumenbas).reorder("ロールメンバ.ロール内序列 asc,ロールメンバ.ロールコード asc")
        end
        if !vars['roru'].empty? && !vars['joutai'].empty?
          @all_events=Event.where(状態コード: vars['joutai'])
          rorumenbas = Rorumenba.where(ロールコード: vars['roru'])
          @shains = Shainmaster.where(タイムライン区分: false).joins(:rorumenbas).where(ロールメンバ: {ロールコード: vars['roru']}).reorder('ロールメンバ.ロールコード asc,ロールメンバ.ロール内序列 asc')
        end
      end

    end
    rescue
      @events = Shainmaster.take.events
    # @all_events = Event.where("Date(開始) = ?", Date.today.to_s(:db))
  end

  def edit
    # @event.build_joutaimaster if @event.joutaimaster.nil?
  end

  def new
    date = Date.today.to_s(:db)
    vars = request.query_parameters
    param_date = vars['start_at']
    # @event = Event.new(shain_no: Shainmaster.find(session[:selected_shain]).id, 開始: "#{date} 09:00", 終了: "#{date} 18:00")
    @event = Event.new(shain_no: Shainmaster.find(session[:selected_shain]).id, 開始: "#{param_date} 09:00", 終了: "#{param_date} 18:00")
  end

  def create_basho
    @basho = Bashomaster.new(basho_params)
    @mybasho = Mybashomaster.new(mybashomaster_params)
    if @basho.save == true
      @mybasho.save
    else
      respond_to do |format|
        # format.js { render 'create_basho_erro'}
        format.js { render json: @basho.errors, status: :unprocessable_entity}
         # format.js { render 'delete'}
      end

    end

    # if @mybasho.save == false
    #   #Mybashomaster.where(社員番号: mybashomaster_params[:社員番号], 場所コード: mybashomaster_params[:場所コード]).first.update mybashomaster_params
    # end

    # @mybasho.save
   # @basho.save
    # @mybasho = Mybashomaster.new(mybashomaster_params)
    # @basho.save
  end

  def create_kaisha
    @kaisha = Kaishamaster.new(kaisha_params)
    if @kaisha.save == false
      respond_to do |format|
        format.js { render json: @kaisha.errors, status: :unprocessable_entity}
      end
    end
  end

  def create
    attributes = event_params.clone
    if event_params[:終了] == '' && event_params[:開始] != ''
      date = Time.now.strftime("%Y/%m/%d")
      attributes[:終了] = "#{date} 18:00"
    end
    dateCheck = event_params[:開始].to_date
    if event_params[:開始] != '' && dateCheck == Date.today
        shozai_id = params[:head][:shozaicode]
        shain = Shainmaster.find(event_params[:社員番号])
        if shozai_id != ''
          shozai = Shozai.find(shozai_id)
          shain.shozai = shozai if shozai
          shain.save
        else
          shain.update(所在コード: '')
        end

    end
    # if attributes[:開始]!= '' && attributes[:終了]!= ''&&attributes[:工数]== ''
    #   attributes[:工数]= get_koushuu(attributes[:開始],attributes[:終了]).to_f.round(2)
    # end

    @event = User.find(session[:user]).shainmaster.events.new attributes

    # flash[:notice] = t 'app.flash.new_success' if @event.save
    # case params[:commit]
    #   when (t 'helpers.submit.create')
    #     respond_with @event, location: time_line_view_events_url, action: 'new',locals: { param: 'timeline'}
    #   when (t 'helpers.submit.create_other')
    #     respond_with @event, location: events_url
    # end

    case params[:commit]
      when (t 'helpers.submit.create')
        respond_to do |format|
          if @event.save
            flash[:notice] = t 'app.flash.new_success'
            format.html { redirect_to time_line_view_events_url }
            format.xml { render xml: @event, status: :created, location: @event }
          else
            format.html {render action: 'new', locals: { param: 'timeline'}}
            format.xml { render xml: @event.errors, status: :unprocessable_entity }
          end
        end
      when (t 'helpers.submit.create_other')
        flash[:notice] = t 'app.flash.new_success' if @event.save
        respond_with @event, location: events_url
    end

  end

  def update

    attributes = event_params.clone
    if event_params[:終了] == '' && event_params[:開始] != ''
      date = Time.now.strftime("%Y/%m/%d")
      attributes[:終了] = "#{date} 18:00"
    end
    dateCheck = event_params[:開始].to_date
    if event_params[:開始] != '' && dateCheck == Date.today && params[:commit] != (t 'helpers.submit.destroy_other') && params[:commit] != (t 'helpers.submit.destroy')
        shozai_id = params[:head][:shozaicode]
        shain = Shainmaster.find(event_params[:社員番号])
        if shozai_id != ''
          shozai = Shozai.find(shozai_id)
          shain.shozai = shozai if shozai
          shain.save
        else
          shain.update(所在コード: '')
        end

    end
    # if attributes[:開始]!= '' && attributes[:終了]!= '' && attributes[:工数]== ''
    #   attributes[:工数]= get_koushuu(attributes[:開始],attributes[:終了]).to_f.round(2)
    # end

    case params[:commit]
      when (t 'helpers.submit.destroy_other')
        flash[:notice] = t 'app.flash.delete_success' if @event.destroy
        respond_with @event, location: events_url
      when (t 'helpers.submit.destroy')
        flash[:notice] = t 'app.flash.delete_success' if @event.destroy
        redirect_to time_line_view_events_url
      when (t 'helpers.submit.create_other')
        flash[:notice] = t 'app.flash.update_success' if @event.update attributes
        respond_with @event, location: events_url
      when (t 'helpers.submit.create')
        respond_to do |format|
          if @event.update attributes
            flash[:notice] = t 'app.flash.update_success'
            format.html { redirect_to time_line_view_events_url }
            format.xml { render xml: @event, status: :created, location: @event }
          else
            format.html {render action: 'edit', locals: { param: 'timeline'}}
            format.xml { render xml: @event.errors, status: :unprocessable_entity }
          end
        end
    end
  end

  def custom
    # if  params[:commit].nil?
    #   shozai_id = params[:shain][:shozai_id]
    #   shozai = Shozai.find shozai_id
    #   shain = User.find(session[:user]).shainmaster
    #   shain.shozai = shozai if shozai
    #   shain.save
    #   redirect_to events_url
    # end
    case params[:commit]
      when (t 'helpers.submit.ok')
        # session[:selected_shain] = Shainmaster.find(params[:selected_user]).id
        session[:selected_shain] = params[:selected_user]
        respond_with @event, location: events_url
      when (t 'helpers.submit.redirect_to_timeline')
        redirect_to time_line_view_events_url
      when (t 'helpers.submit.redirect_to_kintai')
        redirect_to kintais_url
      when (t 'helpers.submit.redirect_to_keihihead')
        redirect_to keihiheads_url
      when (t 'helpers.submit.redirect_to_dengon')
        redirect_to dengons_url
      when (t 'helpers.submit.redirect_to_shonin')
        redirect_to shonin_search_keihiheads_url
      when (t 'helpers.submit.redirect_to_kairan')
        redirect_to kairans_url
      when (t 'helpers.submit.redirect_to_setsubiyoyaku')
        redirect_to setsubiyoyakus_url




    end
  end

  def ajax
   case params[:id]
     when 'event_状態コード'
       joutai_name = Joutaimaster.find_by(状態コード: params[:event_joutai_code]).try(:状態名)
       # event= [{id: '1', resourceId: 'b', start: '2015-08-07 10:00:00', end: '2015-08-07 14:00:00', title: joutai.name }]
       # data = {joutai_name: joutai.name, event: event, event_color: joutai.color, event_text_color: joutai.text_color}
       data = {joutai_name: joutai_name}
       respond_to do |format|
         format.json { render json: data}
       end
     when 'event_場所コード'
       basho_name = Bashomaster.find_by(場所コード: params[:event_basho_code]).try(:場所名)
       data = {basho_name: basho_name}
       respond_to do |format|
         format.json { render json: data}
       end
     when 'event_工程コード'
       koutei_name = get_koutei_name(params[:event_koutei_code],session[:user])
       data = {koutei_name: koutei_name}
       respond_to do |format|
         format.json { render json: data}
       end
     when 'event_job'
       job_name = Jobmaster.find_by(job番号: params[:event_job_code]).try(:job名)
       data = {job_name: job_name}
       respond_to do |format|
         format.json { render json: data}
       end
     when 'save_kinmu_type'
       kinmu_type = params[:data]
       shain = Shainmaster.find(session[:user])
       if shain.update(勤務タイプ: kinmu_type)
         return_data = {message: 'OK'}
       else
         return_data = {message: 'NotOK'}
       end
       respond_to do |format|
         format.json { render json: return_data}
       end
     when 'change_shozai'
       shozai_id = params[:data]
       shozai = Shozai.find(shozai_id)
       shain = User.find(session[:selected_shain]).shainmaster
       shain.shozai = shozai if shozai
       if shain.save
         return_data = {message: 'OK'}
       else
         return_data = {message: 'NotOK'}
       end
       respond_to do |format|
         format.json { render json: return_data}
       end
      when 'kintai_保守携帯回数'
       kintai = Kintai.where(日付: params[:date_kintai],社員番号: session[:user]).first
       Kintai.find(kintai.id).update(保守携帯回数: params[:hoshukeitai])
       data = {kintai_id: kintai.id}
       respond_to do |format|
         format.json { render json: data}
       end
     when 'kintai_getData'
       kintai = Kintai.where(日付: params[:date_kintai],社員番号: session[:user]).first

       data = {kintai_hoshukeitai: kintai.try(:保守携帯回数)}
       respond_to do |format|
         format.json { render json: data}
       end
     when 'roru_getData'
       @roru = Shainmaster.find(session[:user]).rorumaster

       data = {roru: @roru.try(:ロールコード)}
       respond_to do |format|
         format.json { render json: data}
       end
     when 'mybasho_削除する'
       mybasho = Mybashomaster.where(社員番号: params[:shain],場所コード: params[:mybasho_id]).first
       if !mybasho.nil?
         mybasho.destroy
       end

       data = {destroy_success: "success"}
       respond_to do |format|
         format.json { render json: data}
         # format.js { render 'delete'}
       end
     when 'basho_selected'

        mybasho = Mybashomaster.where(社員番号: params[:shain],場所コード: params[:mybasho_id]).first
        if mybasho.nil?
          basho = Bashomaster.find(params[:mybasho_id])
          mybasho = Mybashomaster.new(社員番号: params[:shain],場所コード: params[:mybasho_id],
            場所名: basho.try(:場所名),場所名カナ: basho.try(:場所名カナ), SUB: basho.try(:SUB),
            場所区分: basho.try(:場所区分),会社コード: basho.try(:会社コード))
          mybasho.save
        else
          mybasho.update(updated_at: Time.now)
        end

       data = {destroy_success: mybasho.id}
       respond_to do |format|
         format.json { render json: data}
         # format.js { render 'delete'}
       end
     when 'myjob_削除する'
       myjob = Myjobmaster.where(社員番号: params[:shain],job番号: params[:myjob_id]).first
       if !myjob.nil?
         myjob.destroy
       end

       data = {destroy_success: "success"}
       respond_to do |format|
         format.json { render json: data}
         # format.js { render 'delete'}
       end
     when 'job_selected'
        myjob = Myjobmaster.where(社員番号: params[:shain],job番号: params[:myjob_id]).first
        if myjob.nil?
          job = Jobmaster.find(params[:myjob_id])
          myjob = Myjobmaster.new(社員番号: params[:shain],job番号: params[:myjob_id],
            job名: job.try(:job名),開始日: job.try(:開始日), 終了日: job.try(:終了日),
            ユーザ番号: job.try(:ユーザ番号),ユーザ名: job.try(:ユーザ名),入力社員番号: job.try(:入力社員番号),
            分類コード: job.try(:分類コード),分類名: job.try(:分類名),
            関連Job番号: job.try(:関連Job番号),備考: job.try(:備考))
          myjob.save
        else
          myjob.update(updated_at: Time.now)
        end

       data = {destroy_success: myjob.id}
       respond_to do |format|
         format.json { render json: data}
         # format.js { render 'delete'}
       end
     when "event_drag_update"
        event = Event.find(params[:eventId])
        event.update(社員番号: params[:shainId],開始: params[:event_start], 終了: params[:event_end])
        data = {event: event.id}
        respond_to do |format|
          format.json { render json: data}
        end
     when 'event_destroy'
        eventIds = params[:events]
        eventIds.each{ |eventId|
          Event.find_by(id: eventId).destroy
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
      redirect_to events_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to events_path
    else
      begin
        Event.transaction do
          Event.delete_all
          Event.reset_pk_sequence
          Event.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to events_path
      end
    end
  end

  def export_csv
    @events = Event.all

    respond_to do |format|
      format.html
      format.csv { send_data @events.to_csv, filename: "イベントマスタ.csv" }
    end
  end

private
# Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def set_param
    @jobs = Jobmaster.all
    @shozais = Shozai.all
    @bashos = Bashomaster.all

    @joutais = Joutaimaster.web_use.all
    # @kouteis = User.find(session[:user]).shainmaster.shozokumaster.kouteimasters
    @kouteis = Shainmaster.find(session[:selected_shain]).shozokumaster.kouteimasters
    @basho = Bashomaster.new
    @mybasho = Mybashomaster.new
    @kaisha = Kaishamaster.new
    @kaishamasters = Kaishamaster.all
    vars = request.query_parameters
    if vars['shain_id'].nil?
      @mybashos = Mybashomaster.where(社員番号: session[:selected_shain]).all.order("updated_at desc")
      @myjobs = Myjobmaster.where(社員番号: session[:selected_shain]).all.order("updated_at desc")
    else
      @mybashos = Mybashomaster.where(社員番号: vars['shain_id']).all.order("updated_at desc")
      @myjobs = Myjobmaster.where(社員番号: vars['shain_id']).all.order("updated_at desc")
    end
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:社員番号, :開始, :終了, :状態コード, :場所コード, :JOB, :所属コード, :工程コード, :工数,
                                  :計上, :所在コード, :comment, :有無, :帰社区分)
  end

  def basho_params
    params.require(:mybashomaster).permit(:場所コード, :場所名, :場所名カナ, :SUB, :場所区分, :会社コード)
  end

  def kaisha_params
    params.require(:kaishamaster).permit(:会社コード, :会社名, :備考)
  end

  def mybashomaster_params
    params.require(:mybashomaster).permit(:社員番号, :場所コード, :場所名, :場所名カナ, :SUB, :場所区分,:会社コード, :更新日)
  end
end
