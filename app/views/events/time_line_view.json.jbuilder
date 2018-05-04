json.events @all_events do |event|
  json.id event.id
  json.description event.jobmaster.try(:job名) || ''
  case event.try(:有無)
    when '帰社'
      umu_flag = ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-left"></span>'
    when '直帰'
      umu_flag = ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-bottom"></span>'
    when '連続'
      umu_flag = ' <span style="font-size: 15px;" class="glyphicon glyphicon-triangle-top"></span>'
    else
      umu_flag = ''
  end
  comment = event.comment || event.jobmaster.try(:job名) || ''
  title = event.joutaimaster.try(:name) || ''
  json.joutai title
  if %w(外出 直行 出張 出張移動).include? title
    json.title title + ": " + comment + umu_flag
  else
    json.title title + ": " + comment
  end
  # start_time = event.try(:joutai_code) == '30' ? event.try(:start_time).to_date : event.try(:start_time)
  # end_time = event.try(:joutai_code) == '30' ? event.try(:end_time).to_date : event.try(:end_time)

  json.start event.start_time
  json.end event.end_time
  json.url edit_event_url(event, format: :html,:param => "timeline", :shain_id => event.shainmaster.try(:id))
  json.resourceId event.shainmaster.id
  json.color event.joutaimaster.try(:色)
  json.textColor event.joutaimaster.try(:text_color)
  json.bashokubun event.bashomaster.try(:場所区分)
  json.bashomei event.bashomaster.try(:場所名) || ''
end

json.shains @shains do |shain|
  json.id shain.id
  json.shain shain.氏名
  json.shainid shain.id
  json.linenum shain.内線電話番号
  json.dengon shain.伝言件数 == '0' ? '' : shain.伝言件数
  json.kairan shain.回覧件数 == '0' || shain.id != session[:user] ? '' : shain.回覧件数
end

json.setting do
  json.scrolltime @setting.try(:scrolltime) || '06:00'
end

json.default do
  json.joutai @joutaiDefault.try(:name) if @joutaiDefault
  json.color @joutaiDefault.try(:色) if @joutaiDefault
  json.textColor @joutaiDefault.try(:text_color)  if @joutaiDefault
end
