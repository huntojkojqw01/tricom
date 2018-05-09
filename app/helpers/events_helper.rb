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

  def test_fun(val1)
    return val1.to_f +1

  end  

  # Moi don vi tinh lam tron ve 15 phut, => moi tieng <=> 4 don vi,
  # vi du (0 -> 1 gio) <=> 0,1,2,3 ; (1 -> 2 gio) <=> 4,5,6,7.
  # Cac thoi gian nghi la co dinh nhu sau:
  #-hiru_kyukei: 12->13 <=> 48,49,50,51
  #-yoru_kyukei: 18->19 <=> 72,73,74,75
  #-shinya_kyukei: 23->0 <=> 92,93,94,95
  #-souchou_kyukei: 4->7 <=> 16->27
  # duyet het cac don vi thoi gian tinh tu start -> end, neu co don vi nao thuoc [start,end] thi thoi gian nghi +=1
  # => tinh koushuu chi can tru di thoi gian nghi do la duoc!
  def caculate_koushuu(time_start, time_end)
    results = time_calculate(time_start, time_end)
    return (results[:real_hours] + results[:fustu_zangyo] + results[:shinya_zangyou]) / 15 * 0.25
  end
  # Tao ra mot mang chua cac thoi diem (tinh theo phut) nam trong danh sach cac events:
  def create_event_times(begin_of_day, events)
    events.inject([]) do |array, event|
      event_start_time = ((event.開始.to_time - begin_of_day) / 60).to_i
      event_end_time = ((event.終了.to_time - begin_of_day) / 60).to_i
      array |= (event_start_time...event_end_time).to_a
    end
  rescue
    nil
  end

  def kyuukei_time_calculate(start_t, end_t, event_times = nil) # start va end tinh theo don vi phut
    hiru_kyukei = yoru_kyukei = shinya_kyukei = souchou_kyukei = real_hours = 0
    (start_t...end_t).each do |t|
      next if event_times && !event_times.include?(t)
      case (t / 60) % 24 # tinh xem thoi diem t ung voi may gio trong ngay.
      when 12 then hiru_kyukei += 1 # tuong duong 12:00->13:00
      when 18 then yoru_kyukei += 1
      when 23 then shinya_kyukei += 1
      when 4, 5, 6 then souchou_kyukei += 1
      else real_hours += 1
      end
    end
    return {
      hiru_kyukei: hiru_kyukei,
      yoru_kyukei: yoru_kyukei,
      shinya_kyukei: shinya_kyukei,
      souchou_kyukei: souchou_kyukei,
      real_hours: real_hours,
      fustu_zangyo: 0,
      shinya_zangyou: 0,
      chikoku_soutai: 0
    }
  end

  def zangyou_time_calculate(start_t, end_t, event_times = nil)
    fustu_zangyo = shinya_zangyou = 0
    (start_t...end_t).each do |t|
      next if event_times && !event_times.include?(t)
      case (t / 60) % 24 # tinh xem thoi diem t ung voi may gio trong ngay.
      when 19, 20, 21 then fustu_zangyo += 1
      when 22, 0, 1, 2, 3 then shinya_zangyou += 1
      end
    end
    return [fustu_zangyo, shinya_zangyou]
  end

  def time_calculate(start_time, end_time, kinmu_type = nil, events = nil)
    # quy doi start_time, end_time ra phut:
    begin_of_day = start_time.to_time.beginning_of_day
    start_time = ((start_time.to_time - begin_of_day) / 60).to_i
    end_time = ((end_time.to_time - begin_of_day) / 60).to_i

    # tao danh sach cac thoi diem thuoc events:
    event_times = create_event_times(begin_of_day, events)

    # quy doi thoi gian chuan cua kinmu_type ra phut
    if kinmu_type.present?
      kinmu_start = (Kintai::KINMU_TYPE[kinmu_type][:s] * 60).to_i
      kinmu_end = (Kintai::KINMU_TYPE[kinmu_type][:e] * 60).to_i
    else
      kinmu_start, kinmu_end = 0, 1439 # 00:00->23:59
    end

    if Kintai::KINMU_TYPE.keys.include? kinmu_type
      if start_time <= kinmu_start
        if kinmu_start < end_time # se bat dau dem tu kinmu_start
          results = kyuukei_time_calculate(kinmu_start, end_time, event_times)
          if end_time < kinmu_end # dem den end_time
            # start_time <= kinmu_start < end_time < kinmu_end
            results[:chikoku_soutai] += kinmu_end - end_time # tinh thoi gian ve som
          else # if end_time >= kinmu_end
            # start_time <= kinmu_start < kinmu_end <= end_time
            results[:fustu_zangyo], results[:shinya_zangyou] = zangyou_time_calculate(kinmu_end, end_time, event_times)
          end
        end # if kinmu_start >= end_time then nothing to do
      else # if start_time > kinmu_start thi se dem tu start_time, chikoku > 0
        if start_time < kinmu_end
          if kinmu_end <= end_time # dem den kinmu_end
            # kinmu_start < start_time < kinmu_end <= end_time
            results = kyuukei_time_calculate(start_time, kinmu_end, event_times)
            results[:chikoku_soutai] += start_time - kinmu_start # tinh thoi gian di muon
          else # if kinmu_end > end_time thi dem den end_time
            # kinmu_start < start_time < end_time < kinmu_end
            results[:chikoku_soutai] += start_time - kinmu_start + kinmu_end - end_time
            results = kyuukei_time_calculate(start_time, end_time, event_times)
          end
        end # if start_time >= kinmu_end then nothing to do
      end
    else # Kintai::KINMU_TYPE.keys not include kinmu_type
      results = kyuukei_time_calculate(start_time, end_time, event_times)
      results[:fustu_zangyo], results[:shinya_zangyou] = zangyou_time_calculate(start_time, end_time, event_times)
    end # case kinmu_type
    results[:real_hours] -= results[:fustu_zangyo] + results[:shinya_zangyou]
    return results
  end
end
