module EventsHelper
  
  def get_shozoku(user_id)
    User.find(user_id).shainmaster.shozokumaster
  end
  
  def get_koutei_name(koutei_code, user_id)
    shozoku_code = User.find(user_id).shainmaster.try :所属コード
    Kouteimaster.find_by(所属コード: shozoku_code, 工程コード: koutei_code).try :工程名
  end
  
  # def get_yakushoku(shainbango)
  #   # yakushoku_code = Shainmaster.find_by(連携用社員番号: shainbango).try :役職コード
  #   shain = Shainmaster.find_by(連携用社員番号: shainbango)
  #   yakushoku_name = shain.yakushokumaster.役職名
  #   # Yakushokumaster.find_by(役職コード: yakushoku_code).try :役職名
  #   
  # end

  # def binding_event_by_change_user(user_id)
  #   sql = "SELECT a.*, b.場所名, c.状態名, d.工程名"
  #   sql << " FROM events a LEFT OUTER JOIN 場所マスタ b ON a.場所コード = b.場所コード"
  #   sql << " LEFT OUTER JOIN 状態マスタ c on a.状態コード = c.状態コード"
  #   sql << " LEFT OUTER JOIN 工程マスタ d on a.所属コード = d.所属コード and a.工程コード = d.工程コード"
  #   sql << " WHERE a.社員番号 = '#{user_id}'"
  #   Event.find_by_sql(sql)
  # end

  # def binding_shozoku(shozoku)
  #   sql = "SELECT a.*, b.所属名"
  #   sql << " FROM 工程マスタ a LEFT OUTER JOIN 所属マスタ b ON a.所属コード = b.所属コード"
  #   sql << " WHERE a.所属コード = '#{shozoku}'"
  #   Kouteimaster.find_by_sql(sql)
  # end

  def set_fkey(event, event_params)
    event.joutaimaster = Joutaimaster.find_by 状態コード: event_params[:状態コード]
    event.bashomaster = Bashomaster.find_by 場所コード: event_params[:場所コード]
    event.kouteimaster = Kouteimaster.find_by 所属コード: event_params[:所属コード], 工程コード: event_params[:工程コード]
    # event.shozai = Shozai.find_by 所在コード: event_params[:所在コード]
    event.jobmaster = Jobmaster.find_by job番号: event_params[:JOB]
  end
  
  def check_user_status
    Shainmaster.all.each do |shain|
      if shain.events.where("Date(開始) = ?", Date.current).count == 0
        event_start_datetime = Date.current.to_s + " 09:00"
        event_end_datetime = Date.current.to_s + " 18:00"
        event = Event.new(社員番号: shain.社員番号, 状態コード: '0', 開始: event_start_datetime, 終了: event_end_datetime)
        event.joutaimaster = Joutaimaster.find_by(状態コード: '0')
        event.shainmaster = shain
        event.save
      end
    end
  end
  
  def kitaku
    # shain = User.find(session[:user]).shainmaster
    shain = Shainmaster.find session[:selected_shain]
    
    # event_search = shain.events.where("Date(終了) = ?",Date.today.to_s(:db))
    # .events.where("Date(終了) = ?", Time.now)

    end_time = Date.today.to_s(:db) << ' 18:00'
    event = Event.create(shain_no: shain.shain_no, start_time: Time.now, end_time: end_time, joutai_code: '99')
    event.shainmaster = shain
    event.joutaimaster = Joutaimaster.find_by(code: '99')
    event.save
  end
end
