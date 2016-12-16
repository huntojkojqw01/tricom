json.setsubiyoyakus @setsubiyoyaku do |setsubiyoyaku|
  json.extract! setsubiyoyaku, :id

  description = '設備予約'
  json.description description

  title ='default'
  title = setsubiyoyaku.try(:用件)
  json.title title

  json.start setsubiyoyaku.try(:開始)
  # json.start '2016-06-03 07:00'
  json.end setsubiyoyaku.try(:終了)
  # json.end '2016-06-03 09:00'
  json.url edit_setsubiyoyaku_path(setsubiyoyaku)
  json.color '#67b168'
  json.textColor 'red'
  json.resourceId setsubiyoyaku.try(:開始).to_date
  # json.hizuke setsubiyoyaku.try(:開始)
end

json.hizukes @hizukes do |hizuke|
  json.id hizuke
  json.hizuke hizuke

end
