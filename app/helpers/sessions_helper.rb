module SessionsHelper
  def log_in user
    session[:user] = user.id
    session[:current_user_id] = user.id
    session[:selected_shain] = user.shainmaster.try :id

    unless user.shainmaster.nil?
      if user.shainmaster.login_time.nil?
        Shainmaster.update_all login_time: Date.today
      elsif user.shainmaster.login_time < Date.today
        Shainmaster.update_all 所在コード: nil, login_time: Date.today
      end
    end
        # 現在保留
    # check_shozai()
    check_kintai_at_day_by_user(user.id, Date.today)
    # reset_data_search
    respond_with user, location: time_line_view_events_url
  end
  def set_data_search
    if logged_in?
      Bashokubunmst.rebuild_pg_search_documents
      Bashomaster.rebuild_pg_search_documents
      Bunrui.rebuild_pg_search_documents
      Dengon.rebuild_pg_search_documents
      Dengonkaitou.rebuild_pg_search_documents
      Dengonyouken.rebuild_pg_search_documents
      Eki.rebuild_pg_search_documents
      Event.rebuild_pg_search_documents
      Jobmaster.rebuild_pg_search_documents
      Joutaimaster.rebuild_pg_search_documents
      JptHolidayMst.rebuild_pg_search_documents
      Kairan.rebuild_pg_search_documents
      Kairanyokenmst.rebuild_pg_search_documents
      Kaishamaster.rebuild_pg_search_documents
      Keihihead.rebuild_pg_search_documents
      Kikanmst.rebuild_pg_search_documents
      Kintai.rebuild_pg_search_documents
      Kouteimaster.rebuild_pg_search_documents
      Rorumaster.rebuild_pg_search_documents
      Rorumenba.rebuild_pg_search_documents
      Setsubi.rebuild_pg_search_documents
      Setsubiyoyaku.rebuild_pg_search_documents
      Shainmaster.rebuild_pg_search_documents
      Shoninshamst.rebuild_pg_search_documents
      Shozai.rebuild_pg_search_documents
      Shozokumaster.rebuild_pg_search_documents
      Tsushinseigyou.rebuild_pg_search_documents
      User.rebuild_pg_search_documents
      Yakushokumaster.rebuild_pg_search_documents
      YuukyuuKyuukaRireki.rebuild_pg_search_documents
      Yuusen.rebuild_pg_search_documents
    end
  end
  def reset_data_search
    if logged_in?

      # Bashomaster.rebuild_pg_search_documents
      # Dengon.rebuild_pg_search_documents
      # Dengonkaitou.rebuild_pg_search_documents
      # Dengonyouken.rebuild_pg_search_documents
      # Eki.rebuild_pg_search_documents
      # Jobmaster.rebuild_pg_search_documents
      # JptHolidayMst.rebuild_pg_search_documents
      # Kairan.rebuild_pg_search_documents
      # PgSearch::Document.delete_all(searchable_type: "Kairanshosai")
      # Kairanyokenmst.rebuild_pg_search_documents
      # Keihihead.rebuild_pg_search_documents
      # PgSearch::Document.delete_all(searchable_type: "Keihibody")
      # Kintai.rebuild_pg_search_documents
      # Kouteimaster.rebuild_pg_search_documents
      # Rorumenba.rebuild_pg_search_documents
      # Setsubiyoyaku.rebuild_pg_search_documents
      # PgSearch::Document.delete_all(searchable_type: "Setting")
      # Shainmaster.rebuild_pg_search_documents
      # Shoninshamst.rebuild_pg_search_documents
      # Tsushinseigyou.rebuild_pg_search_documents
      # User.rebuild_pg_search_documents
      # YuukyuuKyuukaRireki.rebuild_pg_search_documents
      Event.rebuild_pg_search_documents
    end
  end
  def current_user
    if session[:current_user_id]
      @current_user ||= User.find_by id: session[:current_user_id]
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete :current_user_id
    session.delete :code
    @current_user = nil
  end

  def current_user? user
    user == current_user
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  def check_kintai_at_day_by_user user_id, at_day = Date.today
    return if Kintai.find_by(日付: at_day, 社員番号: user_id)
    (at_day.beginning_of_month..at_day.end_of_month).each { |day| create_kintai(user_id, day) }
  end

  def check_shozai
    Temp.find_or_create_by(id: 1)
    temp = Temp.find_by(date: Date.today.to_s(:db), checked: true)
    if temp.nil?
      Temp.find(1).update(date: Date.today.to_s(:db), checked: true)
      Shainmaster.update_all 所在コード: 0
    end
  #   Check event that absance that day
    events = Event.where("Date(開始) = ? AND 状態コード = ?", Date.today.to_s(:db),'30')
    events.each do |event|
      event.shainmaster.update 所在コード: 600
    end
  end

  def create_kintai user_id, day
    if JptHolidayMst.exists?(event_date: day)
      note = '会社休日'
      holiday = '1'
    end
    if day.holiday?(:jp)
      holiday = '1'
      note = day.holidays(:jp)[0][:name]
    end

    # kinmu_type = Shainmaster.find(session[:user]).勤務タイプ

    # date = day.to_s
    # case kinmu_type
    #   when '001'
    #     start =  date + ' 07:00:00'

    #   when '002'
    #     start = date + ' 07:30:00'

    #   when '003'
    #     start = date + ' 08:00:00'

    #   when '004'
    #     start = date + ' 08:30:00'

    #   when '005'
    #     start = date + ' 09:00:00'

    #   when '006'
    #     start = date + ' 09:30:00'

    #   when '007'
    #     start = date + ' 10:00:00'

    #   when '008'
    #     start = date + ' 10:30:00'

    #   when '009'
    #     start = date + ' 11:00:00'

    # end

    # Kintai.create!(日付: day, 曜日: day.wday.to_s, 勤務タイプ: kinmu_type, 出勤時刻: start, 社員番号: user_id, holiday: holiday, 備考: note)
    Kintai.create!(日付: day, 曜日: day.wday.to_s, 社員番号: user_id, holiday: holiday, 備考: note)
  end

  def get_unread_messages
    Message.eager_load(:conversation,:user)
            .where("read_at IS ? AND messages.user != ?", nil, current_user.id)
            .where("conversations.sender_id = ? OR conversations.recipient_id = ?", current_user.id, current_user.id)
            .order(created_at: :desc)
  end

  def get_unread_kairans
    Kairanshosai.where(対象者: session[:user], 状態: 0)
  end

  def get_unread_dengons
    Dengon.where(社員番号: session[:user], 確認: false)
  end

  def notify_to(conversation_id = nil, receiver_id = nil) 
    receiver_id = session[:user] unless User.find_by(id: receiver_id)
    if(conversation_id)
      unread_messages = Message.eager_load(:conversation, :user)
                            .where("read_at IS ? AND messages.user != ?", nil, receiver_id)
                            .where(conversation_id: conversation_id)
                            .where("conversations.sender_id = ? OR conversations.recipient_id = ?", receiver_id, receiver_id)
                            .order(created_at: :desc)
    else
      unread_messages = Message.eager_load(:conversation, :user)
                            .where("read_at IS ? AND messages.user != ?", nil, receiver_id)
                            .where("conversations.sender_id = ? OR conversations.recipient_id = ?", receiver_id, receiver_id)
                            .order(created_at: :desc)
    end

    kairans = Kairanshosai.where(対象者: receiver_id, 状態: 0)
    dengons = Dengon.where(社員番号: receiver_id, 確認: false)

    totalCount = unread_messages.size + kairans.size + dengons.size

    items = ''

    unread_messages.each do |message|
      naiyou = message.body.length > 12 ? (message.body[0...12]+ '...') : message.body
      items += '<li><a class=\" fa fa-wechat icon-left start-conversation \" data-sid=\"'+message.conversation.sender_id+'\" data-rip = \"'+ message.conversation.recipient_id+'\" href=\"#\">&nbsp;&nbsp;&nbsp;'+ message.user&.name.to_s+': '+naiyou+'</a></li>' if message.body
    end
    items += '<legend class=\"menu\"></legend>' if unread_messages.any?

    kairans.each do |kairan|
      naiyou = kairan.内容.length > 12 ? (kairan.内容[0...12]+'...') : kairan.内容
      items = items + '<li><a class=\"glyphicon glyphicon-envelope icon-left\" href=\"/kairans?locale=ja&search='+kairan.内容+' \"> '+ naiyou+'</a></li>' if kairan.内容
    end
    items += '<legend class=\"menu\"></legend>' if unread_messages.any? && kairans.any?

    dengons.each do |dengon|
      naiyou = dengon.伝言内容.length > 12 ? (dengon.伝言内容[0...12]+ '...') : dengon.伝言内容
      items += '<li><a class=\"glyphicon glyphicon-comment icon-left\" href=\"/dengons?locale=ja&search='+dengon.伝言内容+' \"> '+ naiyou+'</a></li>' if dengon.伝言内容
    end

    PrivatePub.publish_to("/messages/" + receiver_id,
                "if(#{totalCount} > 0){
                  if($('.glyphicon-bell').hasClass('text-red') == false){
                      $('.glyphicon-bell').addClass('text-red');
                      $('.message-count').addClass('text-red');
                  }
                  $('.message-count').text(#{totalCount})
                  $('.message-item').css('display','')
                  $('.message-item').html(\'"+items+"\')
                }else{
                  if($('.glyphicon-bell').hasClass('text-red')){
                    $('.glyphicon-bell').removeClass('text-red');
                    $('.message-count').removeClass('text-red');
                  }
                  $('.message-item').css('display','none')
                  $('.message-count').text('')
                  $('.message-item').html('')
                }")
  end
end
