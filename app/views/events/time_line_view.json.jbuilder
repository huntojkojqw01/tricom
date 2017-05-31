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
  umu_flag = ''
  case event.try(:有無)
    when '帰社'
      umu_flag = ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-left"></span>'
    when '直帰'
      umu_flag = ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-bottom"></span>'
    when '連続'
      umu_flag = ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-top"></span>'
  end
  comment = ''
  comment = event.try(:comment) if event.try(:comment)
  title =''
  title = event.joutaimaster.try(:name) if event.joutaimaster
  json.joutai title
  # title = event.joutaimaster.try(:name) << kisha_flag if event.joutaimaster
  # title = event.jobmaster.try(:job_name) << kisha_flag if event.joutaimaster
  if title == '外出' || title == '直行' || title == '出張' || title == '出張移動'
    json.title title + ": " +comment+umu_flag
  else
    json.title title + ": " +comment
  end
  # start_time = event.try(:joutai_code) == '30' ? event.try(:start_time).to_date : event.try(:start_time)
  # end_time = event.try(:joutai_code) == '30' ? event.try(:end_time).to_date : event.try(:end_time)

  json.start event.try(:start_time)
  # json.start '2016-06-03 07:00'
  json.end event.try(:end_time)
  # json.end '2016-06-03 09:00'
  json.url edit_event_url(event, format: :html,:param => "timeline", :shain_id => event.shainmaster.id)
  json.resourceId event.shainmaster.id if event.shainmaster
  json.color event.joutaimaster.try(:色) if event.joutaimaster
  json.textColor event.joutaimaster.try(:text_color)  if event.joutaimaster
  json.bashokubun event.bashomaster.try(:場所区分) if event.bashomaster
end

json.shains @shains do |shain|
  json.extract! shain, :id
  json.shain shain.try(:氏名)
  json.shainid shain.try(:id)
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
  dengon = shain.try(:伝言件数) == '0' ? '' : shain.try(:伝言件数)
  json.dengon dengon
  kairan = shain.try(:回覧件数) == '0' ? '' : shain.try(:回覧件数)
  json.kairan kairan
  background_color = ''
  background_color = shain.shozai.try :background_color if shain.shozai
  json.background_color background_color

  text_color = ''
  text_color = shain.shozai.try :text_color if shain.shozai
  json.text_color text_color

  # json.eventColor shain.events.first.joutaimaster.色 if shain.events.first
end

# json.setting @setting.try(:scrolltime) if @setting
# json.setting '06:00' if !@setting


json.setting do
  json.scrolltime @setting.try(:scrolltime) if @setting
  json.scrolltime '06:00' if !@setting

end

json.default do
  json.joutai @joutaiDefault.try(:name) if @joutaiDefault
  json.color @joutaiDefault.try(:色) if @joutaiDefault
  json.textColor @joutaiDefault.try(:text_color)  if @joutaiDefault
end