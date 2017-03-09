json.events @all_events do |event|
  json.extract! event, :id
  description = ''
  description = event.jobmaster.try(:job名) if event.jobmaster
  json.description description
  # json.title event.bashomaster.try :場所名
  # kisha_flag = ''
  # case event.try(:kisha)
  #   when '帰社'
  #     kisha_flag = '　◯'
  #   when '直帰'
  #     kisha_flag = '　☓'
  #   when '連続'
  #     kisha_flag = '　△'
  # end
  title =''
  title = event.joutaimaster.try(:name) if event.joutaimaster
  # title = event.joutaimaster.try(:name) << kisha_flag if event.joutaimaster
  # title = event.jobmaster.try(:job_name) << kisha_flag if event.joutaimaster
  json.title title
  # start_time = event.try(:joutai_code) == '30' ? event.try(:start_time).to_date : event.try(:start_time)
  # end_time = event.try(:joutai_code) == '30' ? event.try(:end_time).to_date : event.try(:end_time)

  json.start event.try(:start_time)
  json.end event.try(:end_time)
  json.url edit_event_url(event, format: :html,:shain_id => event.shainmaster.id)
  json.resourceId event.shainmaster.id if event.shainmaster
  json.color event.joutaimaster.try(:色) if event.joutaimaster
  json.textColor event.joutaimaster.try(:text_color)  if event.joutaimaster
end

json.my_events @events do |my_event|
  json.extract! my_event, :id
  description = ''
  # description = my_event.jobmaster.try(:job名) if my_event.jobmaster
  description = my_event.joutaimaster.try(:name) if my_event.joutaimaster
  json.description description
  # json.title event.bashomaster.try :場所名
  # json.title my_event.joutaimaster.try(:name)+"aaa" if my_event.joutaimaster
  # comment = ''
  comment = ''
  comment = my_event.try(:comment)
  job = ''
  job = my_event.jobmaster.try(:job名) if my_event.jobmaster
  json.comment comment
  title = my_event.joutaimaster.try(:name) if my_event.joutaimaster
  json.job job
  json.title title
  json.start my_event.try(:start_time)
  json.end my_event.try(:end_time)
  json.url edit_event_url(my_event, format: :html,:shain_id => my_event.shainmaster.id)
  json.resourceId my_event.shainmaster.id if my_event.shainmaster
  json.color my_event.joutaimaster.try(:color) if my_event.joutaimaster
  json.textColor my_event.joutaimaster.try(:text_color)  if my_event.joutaimaster
end

json.shains @shains do |shain|
  json.extract! shain, :id
  json.shain shain.try(:氏名)
  # json.joutai shain.events.first.shozai.try(:所在名) if shain.events.first
  # event = shain.events.where("開始 < ? AND 終了 > ?",Time.current, Time.current).first
  joutai = ''
  # joutai = event.shozai.try(:name) if event
  joutai = shain.shozai_所在名
  # joutai = event.joutai_状態名 if event
  json.joutai joutai

  # json.joutai shain.events.where("開始 < ? AND 終了 > ?", Time.now, Time.now).first.joutaimaster.try(:状態名) if shain.events.where("開始 < ? AND 終了 > ?",Time.now, Time.now).first
  json.shozoku shain.shozokumaster.try(:所属名) if shain.shozokumaster
  json.linenum shain.try :内線電話番号
  json.yakushoku shain.yakushokumaster.try(:役職名) if shain.yakushokumaster
  json.dengon shain.try :伝言件数
  json.kairan shain.try :回覧件数
  background_color = ''
  background_color = shain.shozai.try :background_color if shain.shozai
  json.background_color background_color

  text_color = ''
  text_color = shain.shozai.try :text_color if shain.shozai
  json.text_color text_color

  # json.eventColor shain.events.first.joutaimaster.色 if shain.events.first
end

json.holidays @holidays do |holiday|
  json.extract! holiday, :id
  json.title holiday.try(:title)
  json.description holiday.try(:description)
  json.start holiday.try(:event_date)
  json.end holiday.try(:event_date)
  json.color 'red'
end

json.setting do
  json.select_holiday_vn @setting.try(:select_holiday_vn) if @setting
  json.select_holiday_vn '0' if !@setting
end