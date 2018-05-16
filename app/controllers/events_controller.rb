class EventsController < ApplicationController
  before_action :require_user!
  before_action :set_event, only: [ :show, :edit, :update, :destroy]
  before_action :set_param, only: [ :create, :new, :show, :edit, :update, :destroy, :shutchou_ikkatsu_new, :shutchou_create]
  # load_and_authorize_resource
  respond_to :json

  include EventsHelper

  def index
    @shains = Shainmaster.includes(:shozokumaster, :yakushokumaster, :shozai).reorder(:序列, :社員番号).where(社員番号: User.all.ids)
    session[:selected_shain] = current_user.id unless session[:selected_shain].present?
    @events = Event.includes(:jobmaster, :joutaimaster, :kouteimaster, bashomaster: :kaishamaster )
                  .where(社員番号: session[:selected_shain])
                  .order(開始: :desc)
    @shain = Shainmaster.find(session[:selected_shain])
    @kintai = Kintai.first
    @selected_date = session[:selected_date] || Date.current

    @data = {
              :events => build_calendar_event_json(@events),
              :setting => { select_holiday_vn: Setting.find_by(社員番号: session[:selected_shain]).try(:select_holiday_vn) || '0' },
              :holidays => build_calendar_holiday_json(JptHolidayMst.all)
            }.to_json
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
      where('Date(開始) >= ?',@date_start.to_date.to_s(:db)).
      where('Date(終了) <= ?',@date_end.to_date.to_s(:db)).
      where('経費精算 = ?',true).
      order(開始: :asc)
    @events.each{ |event|
        Event.find_by(id: event.id).update(工数: caculate_koushuu(event.開始, event.終了))
    }
    @shain = Shainmaster.find(session[:selected_shain])
    date = @date_start.to_date
    respond_to do |format|
      format.pdf do
        render  pdf: 'event_pdf',
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
      where('Date(開始) >= ?',@date_start.to_date.to_s(:db)).
      where('Date(終了) <= ?',@date_end.to_date.to_s(:db))
    @events.each{ |event|
        Event.find_by(id: event.id).update(工数: caculate_koushuu(event.開始, event.終了))
    }
    # 'JOB, 工数'
    @eventJOB = @events.select('JOB','SUM(CAST(工数 AS DECIMAL)) AS sum_job').group(:JOB).order(:JOB)
    # @problems = @test.select('JOB','工数').group(:JOB).order(:JOB).sum('CAST(events.工数 AS DECIMAL)')
     # te = Kintai.select('勤務タイプ','SUM(実労働時間) AS KKK').group(:勤務タイプ).order(:勤務タイプ => :asc)
    @shain = Shainmaster.find(session[:selected_shain])
    date = @date_start.to_date
    respond_to do |format|
      format.pdf do
        render  pdf: 'event_job_pdf',
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
      where('Date(開始) >= ?',@date_start.to_date.to_s(:db)).
      where('Date(終了) <= ?',@date_end.to_date.to_s(:db))
    @events.each{ |event|
        Event.find_by(id: event.id).update(工数: caculate_koushuu(event.開始, event.終了))
    }
    # 'JOB, 工数'
    @eventKoutei = @events.select('JOB','工程コード','SUM(CAST(工数 AS DECIMAL)) AS sum_job').group(:JOB,:工程コード).order(:JOB)
    # @problems = @test.select('JOB','工数').group(:JOB).order(:JOB).sum('CAST(events.工数 AS DECIMAL)')
     # te = Kintai.select('勤務タイプ','SUM(実労働時間) AS KKK').group(:勤務タイプ).order(:勤務タイプ => :asc)
    @shain = Shainmaster.find(session[:selected_shain])
    date = @date_start.to_date
    respond_to do |format|
      format.pdf do
        render  pdf: 'event_koutei_pdf',
                title: (t 'app.label.pdf_event_koutei'),
                template: 'events/pdf_koutei_show.pdf.erb',
                encoding: 'utf8',
                orientation: 'Landscape'
      end
    end
  end

  def time_line_view
    @selected_date = session[:selected_date] || Date.today.strftime('%Y/%m/%d')    
    @events = Event.includes(:joutaimaster, { bashomaster: :kaishamaster } , :jobmaster, :kouteimaster)
                    .where(社員番号: session[:selected_shain]).where('Date(開始) >= ?', 1.month.ago(Date.today))
                    .order(開始: :desc)
    @kitaku_event = Event.where(社員番号: session[:user], 状態コード: '99').where('Date(開始) = ?', Date.today)    
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
      current_time_text = "#{@selected_date} #{Time.now.strftime('%H:%M')}"
      @shains = Shainmaster.where(タイムライン区分: false)
      session[:selected_roru] = vars['roru'] if vars['roru'].present?
      @shains = @shains.joins(:rorumenbas).where(ロールメンバ: { ロールコード: session[:selected_roru] }) if session[:selected_roru]
      session[:selected_joutai] = vars['joutai'] if vars['joutai'].present?
      if session[:selected_joutai]
        if session[:selected_joutai] == '00' # 不在 chossen.
          shain_ids = Shainmaster.pluck(:社員番号).uniq - Event.where(" ? BETWEEN 開始 AND 終了", current_time_text)
                                                              .where.not(状態コード: '00')
                                                              .pluck(:社員番号).uniq
        else
          shain_ids = Event.where(" ? BETWEEN 開始 AND 終了", current_time_text)
                            .where(状態コード: session[:selected_joutai])
                            .pluck(:社員番号).uniq
        end
        @shains = @shains.where(社員番号: shain_ids)
      end
      @all_events = Event.includes(:jobmaster, :joutaimaster, :bashomaster).where(社員番号: @shains.ids.uniq)
      @events = Event.includes(:joutaimaster, { bashomaster: :kaishamaster } , :jobmaster, :kouteimaster)
                    .where(社員番号: @shains.ids.uniq).where('Date(開始) >= ?', 1.month.ago(Date.today))
                    .order(開始: :desc)
    end

    joutaiDefault = Joutaimaster.find_by(状態コード: '00')
    @data = { 
            :events => build_event_json(@all_events),
            :shains => build_shain_json(@shains),
            :setting => { scrolltime: Setting.find_by(社員番号: session[:user]).try(:scrolltime) || '06:00' },
            :default => {
                          joutai: joutaiDefault.name,
                          color: joutaiDefault.色,
                          textColor: joutaiDefault.text_color
                        }
    }.to_json   
    rescue => e
      p e
      @events = Shainmaster.take.events.includes(:joutaimaster, :bashomaster, :jobmaster, :kouteimaster)
  end

  def edit
    # @event.build_joutaimaster if @event.joutaimaster.nil?
  end

  def new
    vars = request.query_parameters
    param_date = vars['start_at'] || Date.today.strftime("%Y/%m/%d")
    param_shain = vars['shain_id'] || session[:selected_shain]
    event = Event.where(社員番号: param_shain)
                 .where.not(終了: '')
                 .where('Date(終了) = ?', param_date)
                 .order(終了: :desc)
                 .first
    @event = Event.new(社員番号: session[:selected_shain], 開始: event.try(:終了) || "#{param_date} 09:00", 終了: "#{param_date} 18:00")
  end

  def shutchou_ikkatsu_new
    date = Date.today.to_s(:db)
    vars = request.query_parameters
    # param_date = vars['start_at']
    param_date = vars['start_at'] || Date.today.to_s
    @event = Event.new(shain_no: Shainmaster.find(session[:selected_shain]).id, 開始: "#{param_date} 09:00", 終了: "#{param_date} 18:00")

  end
  def shutchou_create
    attributes = event_params.clone
    @event = User.find(session[:user]).shainmaster.events.new attributes
    case params[:commit]
      when (t 'helpers.submit.create')
        respond_to do |format|
          if @event.save
            if params[:event1][:状態コード]!= ''
              event1_attr = event_params.clone
              event1_attr[:開始] = params[:event1_start]
              event1_attr[:終了] = params[:event1_end]
              event1_attr[:状態コード] = params[:event1][:状態コード]
              event1_attr[:工数] = params[:event1_koushuu]
              event1 = User.find(session[:user]).shainmaster.events.new event1_attr
              event1.save
            end
            if params[:event3][:状態コード]!= ''
              event3_attr = event_params.clone
              event3_attr[:開始] = params[:event3_start]
              event3_attr[:終了] = params[:event3_end]
              event3_attr[:状態コード] = params[:event3][:状態コード]
              event3_attr[:工数] = params[:event3_koushuu]
              event3 = User.find(session[:user]).shainmaster.events.new event3_attr
              event3.save
            end
            flash[:notice] = t 'app.flash.new_success'
            format.html { redirect_to time_line_view_events_url }
            format.xml { render xml: @event, status: :created, location: @event }
          else
            format.html {render action: 'shutchou_ikkatsu_new',
              locals: { param: 'timeline',
                event1_joutai: params[:event1][:状態コード], event1_start: params[:event1_start], event1_end: params[:event1_end],
                event1_koushuu: params[:event1_koushuu], event1_umu: params[:event1][:有無],
                event3_joutai: params[:event3][:状態コード], event3_start: params[:event3_start], event3_end: params[:event3_end],
                event3_koushuu: params[:event3_koushuu], event3_umu: params[:event3][:有無]}}
            format.xml { render xml: @event.errors, status: :unprocessable_entity }
          end
        end
      when (t 'helpers.submit.create_other')
        respond_to do |format|
          if @event.save
            if params[:event1][:状態コード]!= ''
              event1_attr = event_params.clone
              event1_attr[:開始] = params[:event1_start]
              event1_attr[:終了] = params[:event1_end]
              event1_attr[:状態コード] = params[:event1][:状態コード]
              event1_attr[:工数] = params[:event1_koushuu]
              event1 = User.find(session[:user]).shainmaster.events.new event1_attr
              event1.save
            end
            if params[:event3][:状態コード]!= ''
              event3_attr = event_params.clone
              event3_attr[:開始] = params[:event3_start]
              event3_attr[:終了] = params[:event3_end]
              event3_attr[:状態コード] = params[:event3][:状態コード]
              event3_attr[:工数] = params[:event3_koushuu]
              event3 = User.find(session[:user]).shainmaster.events.new event3_attr
              event3.save
            end
            flash[:notice] = t 'app.flash.new_success'
            format.html { redirect_to events_url }
            format.xml { render xml: @event, status: :created, location: @event }
          else
            format.html {render action: 'shutchou_ikkatsu_new',
              locals: { param: 'event',
                event1_joutai: params[:event1][:状態コード], event1_start: params[:event1_start], event1_end: params[:event1_end],
                event1_koushuu: params[:event1_koushuu], event1_umu: params[:event1][:有無],
                event3_joutai: params[:event3][:状態コード], event3_start: params[:event3_start], event3_end: params[:event3_end],
                event3_koushuu: params[:event3_koushuu], event3_umu: params[:event3][:有無]}}
            format.xml { render xml: @event.errors, status: :unprocessable_entity }
          end
        end
    end
  end
  def create_kaisha
    @kaisha = Kaishamaster.new(kaisha_params)
    if @kaisha.save == false
      respond_to do |format|
        format.js { render json: @kaisha.errors, status: :unprocessable_entity}
      end
    end
  end

  def update_kaisha
    @kaishamaster = Kaishamaster.find(kaisha_params[:会社コード])
    respond_to do |format|
      if  @kaishamaster.update(kaisha_params)
        format.js { render 'edit_kaisha'}
      else
        format.js { render json: @kaishamaster.errors, status: :unprocessable_entity}
      end
    end
  end

  def create_basho
    @basho = Bashomaster.new(bashomaster_params)
    if @basho.save == false
      respond_to do |format|
        format.js { render json: @basho.errors, status: :unprocessable_entity}
      end
    end
  end

  def update_basho
    @bashomaster = Bashomaster.find(bashomaster_params[:場所コード])
    respond_to do |format|
      if  @bashomaster.update(bashomaster_params)
        format.js { render 'edit_basho'}
      else
        format.js { render json: @bashomaster.errors, status: :unprocessable_entity}
      end
    end
  end

  def create_job
    @jobmaster = Jobmaster.new(jobmaster_params)

    respond_to do |format|
      if @jobmaster.save
        format.js { render 'create_job'}
      else
        format.js { render json: @jobmaster.errors, status: :unprocessable_entity}
      end
    end
  end
  def update_job
    @jobmaster = Jobmaster.find(jobmaster_params[:job番号])
    respond_to do |format|
      if  @jobmaster.update(jobmaster_params)
        format.js { render 'edit_job'}
      else
        format.js { render json: @jobmaster.errors, status: :unprocessable_entity}
      end
    end
  end

  def create
    attributes = event_params.clone    
    attributes[:終了] = "#{ Time.now.strftime('%Y/%m/%d') } 18:00" if attributes[:開始].present? && attributes[:終了].blank?
    if attributes[:状態コード].present?
      joutai_kubun = Joutaimaster.find_by(状態コード: attributes[:状態コード]).try(:状態区分)
      unless joutai_kubun.in?(['1', '5'])
        attributes[:場所コード] = ''
        attributes[:JOB] = ''
        attributes[:工程コード] = ''
      end
    end
    @event = User.find(session[:user]).shainmaster.events.new attributes
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
        end # if @event.save
      end
    when (t 'helpers.submit.create_other')
      flash[:notice] = t 'app.flash.new_success' if @event.save        
      respond_with @event, location: events_url
    end
  end

  def update
    attributes = event_params.clone    
    attributes[:終了] = "#{ Time.now.strftime('%Y/%m/%d') } 18:00" if attributes[:開始].present? && attributes[:終了].blank?
    if attributes[:状態コード].present?
      joutai_kubun = Joutaimaster.find_by(状態コード: attributes[:状態コード]).try(:状態区分)
      unless joutai_kubun.in?(['1', '5'])
        attributes[:場所コード] = ''
        attributes[:JOB] = ''
        attributes[:工程コード] = ''
      end
    end    

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
      when (t 'helpers.submit.create_clone')
        @event = User.find(session[:user]).shainmaster.events.new attributes
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
      when (t 'helpers.submit.create_clone_other')
        @event = User.find(session[:user]).shainmaster.events.new attributes
        respond_to do |format|
          if @event.save
            flash[:notice] = t 'app.flash.new_success'
            format.html { redirect_to events_url }
            format.xml { render xml: @event, status: :created, location: @event }
          else
            format.html {render action: 'new', locals: { param: 'timeline'}}
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
      when current_user.担当者名称
        session[:selected_shain] = current_user.id
        respond_with @event, location: events_url
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
     when 'change_shozai_timeline'
       shozai_id = params[:data]
       shozai = Shozai.find(shozai_id)
       shain = User.find(session[:user]).shainmaster
       shain.shozai = shozai if shozai

       if shain.save
         joutai = ''
         joutai = shain.shozai_所在名 if shain.shozai
         background_color = ''
         background_color = shain.shozai.try :background_color if shain.shozai
         text_color = ''
         text_color = shain.shozai.try :text_color if shain.shozai
         return_data = {message: 'OK', resourceID: session[:user], joutai: joutai,bgColor: background_color, color: text_color }
       else
         return_data = {message: 'NotOK'}
       end
       respond_to do |format|
         format.json { render json: return_data}
       end
      when 'kintai_保守携帯回数'
       kintai = Kintai.find_by(日付: params[:date_kintai],社員番号: session[:user])
       kintai.update(保守携帯回数: params[:hoshukeitai]) if kintai
       respond_to do |format|
         format.json { render json: { kintai_id: kintai.try(:id) } }
       end
     when 'kintai_getData'
       date = params[:date_kintai].to_date
       data = ((date.beginning_of_month-7.day)..(date.end_of_month+14.day)).inject({}) { |hash, date| hash[date.to_s] = nil; hash } 
       Kintai.where(日付: (date.beginning_of_month-7.day)..(date.end_of_month+14.day))
              .each_with_object(data) { |kintai, data| data[kintai.日付.to_s] = kintai.保守携帯回数 }
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

       data = {destroy_success: 'success'}
       respond_to do |format|
         format.json { render json: data}
         # format.js { render 'delete'}
       end
     when 'basho_selected'
        @mybasho = Mybashomaster.find_by(社員番号: params[:shain], 場所コード: params[:mybasho_id])
        if @mybasho
          @mybasho.update(updated_at: Time.now)
          respond_to do |format|
            format.json { render json: { mybasho_id: @mybasho.id } }
          end          
        else
          basho = Bashomaster.find_by(場所コード: params[:mybasho_id])
          @mybasho = Mybashomaster.new(basho.slice(:場所コード, :場所名, :場所名カナ, :SUB, :場所区分, :会社コード)
                                             .merge(社員番号: params[:shain]))
          if @mybasho.save
            respond_to do |format|
              format.js { render 'create_mybasho'}
            end
          end
        end


     when 'myjob_削除する'
       myjob = Myjobmaster.where(社員番号: params[:shain],job番号: params[:myjob_id]).first
       if !myjob.nil?
         myjob.destroy
       end

       data = {destroy_success: 'success'}
       respond_to do |format|
         format.json { render json: data}
         # format.js { render 'delete'}
       end
     when 'job_selected'
        @myjob = Myjobmaster.find_by(社員番号: params[:shain], job番号: params[:myjob_id])
        if @myjob
          @myjob.update(updated_at: Time.now)
          respond_to do |format|
            format.json { render json: { myjob_id: @myjob.id } }
          end          
        else
          job = Jobmaster.find_by(job番号: params[:myjob_id])
          if job
            @myjob = Myjobmaster.new(job.slice(:job番号, :job名, :開始日, :終了日, :ユーザ番号, :ユーザ名, :入力社員番号, :分類コード, :分類名, :関連Job番号, :備考)
                                        .merge(社員番号: params[:shain]))
            if @myjob.save
              respond_to do |format|
                format.js { render 'create_myjob'}
              end
            end
          end
        end

     when 'event_drag_update'
        event = Event.find(params[:eventId])
        event.update(社員番号: params[:shainId],開始: params[:event_start], 終了: params[:event_end])
        data = {event: event.id}
        respond_to do |format|
          format.json { render json: data}
        end
     # when 'event_drag_check'
     #    event = Event.find(params[:eventId])
     #    if event.社員番号 == params[:shainId]
     #      data = {check: 'OK'}
     #    else
     #      data = {check: 'NOT OK'}
     #    end
     #    respond_to do |format|
     #      format.json { render json: data}
     #    end
     when 'event_destroy'
        eventIds = params[:events]
        eventIds.each{ |eventId|
          Event.find_by(id: eventId).destroy
        }
        data = {destroy_success: 'success'}
        respond_to do |format|
          format.json { render json: data}
        end
     when 'get_job_selected'
      job = Jobmaster.find(params[:job_id])
      data = {job: job}
      respond_to do |format|
         format.json { render json: data}
       end
     when 'get_basho_selected'
      basho = Bashomaster.find(params[:basho_id])
      data = {basho: basho}
      respond_to do |format|
         format.json { render json: data}
       end
     when 'create_kitaku_event'
      @kitaku_events = Shainmaster.find(session[:user]).events.
      where('開始 <= ?',DateTime.parse(params[:time_start]).to_s(:db)).
      where('終了 >= ?',DateTime.parse(params[:time_start]).to_s(:db))
      # where('DateTime(終了) <= ?',params[:time_start].to_date.to_s(:db))
      if @kitaku_events.count > 0
        data = {create_message: 'FAIL'}
      else
        event = Event.create(社員番号: session[:user], 開始: params[:time_start], 終了: params[:time_end], 状態コード: '99')
        data = {create_message: 'OK'}
      end
      respond_to do |format|
         format.json { render json: data}
      end
     when 'get_kousuu'
      kousuu = caculate_koushuu(params[:start_time], params[:end_time]).to_f.round(2)
      data = {kousuu: kousuu}
      respond_to do |format|
         format.json { render json: data}
      end
     when 'get_kintais'
      case params[:joutai]
      when '105' then joutai_aite = '103'
      when '109' then joutai_aite = '107'
      when '113' then joutai_aite = '111'
      end
      @kintais = Kintai.where(社員番号: params[:shain], 代休取得区分: '0',状態1: joutai_aite )
                       .select(:日付, :id)
      respond_to do |format|
        # format.json { render json: 'data'}
        format.js { render 'reset_daikyu_modal'}
      end
   end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to events_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
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
      format.csv { send_data @events.to_csv, filename: 'イベントマスタ.csv' }
    end
  end

private
# Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def set_param
    @jobs = Jobmaster.includes(:bunrui)
    @shozais = Shozai.all
    @bashos = Bashomaster.includes(:kaishamaster)

    @joutais = Joutaimaster.web_use.all
    @joutaimaster = Joutaimaster.new
    # @kouteis = User.find(session[:user]).shainmaster.shozokumaster.kouteimasters
    vars = request.query_parameters
    shozoku = Shainmaster.find_by_id(vars['shain_id'] || session[:selected_shain]).try(:shozokumaster)
    @kouteis = shozoku ? shozoku.kouteimasters.order(:工程コード) : []
    @basho = Bashomaster.new

    @kaisha = Kaishamaster.new
    @kaishamasters = Kaishamaster.all
    if vars['shain_id'].nil?
      @mybashos = Mybashomaster.includes(:kaishamaster).where(社員番号: session[:selected_shain]).order('updated_at desc')
      @myjobs = Myjobmaster.includes(:bunrui).where(社員番号: session[:selected_shain]).order('updated_at desc')
    else
      @mybashos = Mybashomaster.includes(:kaishamaster).where(社員番号: vars['shain_id']).order('updated_at desc')
      @myjobs = Myjobmaster.includes(:bunrui).where(社員番号: vars['shain_id']).order('updated_at desc')
    end
    max_job = Jobmaster.pluck(:job番号).map {|i| i.to_i}.max + 1
    # max_job = Jobmaster.maximum(:job番号) + 1
    max_job = 100001 if max_job < 100001
    @jobmaster = Jobmaster.new
    @shains = Shainmaster.all
    @bunruis = Bunrui.all
    @daikyus = Kintai.where(社員番号: session[:user], 代休取得区分: '0').select(:日付, :id) # variable for daikyu_modal
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:社員番号, :開始, :終了, :状態コード, :場所コード, :JOB, :所属コード, :工程コード, :工数,
                                  :計上, :所在コード, :comment, :有無, :帰社区分, :経費精算)
                          .merge(:kintai_daikyu_date => params[:kintai_daikyu])

  end

  def bashomaster_params
    params.require(:bashomaster).permit(:場所コード, :場所名, :場所名カナ, :SUB, :場所区分, :会社コード)
  end

  def kaisha_params
    params.require(:kaishamaster).permit(:会社コード, :会社名, :備考)
  end
  def jobmaster_params
    params.require(:jobmaster).permit(:job番号, :job名, :開始日, :終了日, :ユーザ番号, :ユーザ名, :入力社員番号, :分類コード, :分類名, :関連Job番号, :備考)
  end

  def build_calendar_event_json(events)
    events.map do |my_event|
      {
        id: my_event.id,
        description: my_event.joutaimaster.try(:name) || '',
        comment: my_event.comment,
        job: my_event.jobmaster.try(:job名) || '',
        title: my_event.joutaimaster.try(:name) || '',
        start: my_event.start_time,
        end: my_event.end_time,
        url: edit_event_url(my_event, format: :html, :shain_id => my_event.社員番号),
        resourceId: my_event.社員番号,
        color: my_event.joutaimaster.try(:color),
        textColor: my_event.joutaimaster.try(:text_color),
        bashomei: my_event.bashomaster.try(:場所名) || ''
      }
    end
  end

  def build_calendar_holiday_json(holidays)
    holidays.map do |holiday|
      {
        id: holiday.id,
        title: holiday.title,
        description: holiday.description,
        start: holiday.event_date,
        end: holiday.event_date,
        color: 'red'
      }
    end
  end

  def build_event_json(events)
    umu_flag = {
      '帰社' => ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-left"></span>',
      '直帰' => ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-bottom"></span>',
      '連続' => ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-top"></span>',
    }
    events.map do |event|
      {
        id: event.id,
        description: event.jobmaster.try(:job名) || '',
        joutai: event.joutaimaster.try(:name) || '',
        title: "#{event.joutaimaster.try(:name) || ''}: #{event.comment || event.jobmaster.try(:job名) || ''}#{umu_flag[event.有無]}",
        start: event.start_time,
        end: event.end_time,
        url: edit_event_url(event, format: :html,:param => "timeline", :shain_id => event.社員番号),
        resourceId: event.社員番号,
        color: event.joutaimaster.try(:色),
        textColor: event.joutaimaster.try(:text_color),
        bashokubun: event.bashomaster.try(:場所区分),
        bashomei: event.bashomaster.try(:場所名) || ''
      }
    end
  end

  def build_shain_json(shains)
    shains.map do |shain|
      {
        id: shain.id,
        shain: shain.氏名,
        linenum: shain.内線電話番号,
        dengon: shain.伝言件数 && shain.伝言件数 != '0' ? shain.伝言件数 : '',
        kairan: (shain.回覧件数 == '0' || shain.id != session[:user]) ? '' : shain.回覧件数
      }
    end
  end

end
