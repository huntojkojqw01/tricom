json.setsubiyoyakus @setsubiyoyaku do |setsubiyoyaku|
  json.extract! setsubiyoyaku, :id

  description = ''
  description = setsubiyoyaku.setsubi.try(:設備名) if setsubiyoyaku.setsubi
  json.description description

  title ='default'
  title = setsubiyoyaku.try(:用件)
  shain = ''
  shain = '社員の氏名: '+ setsubiyoyaku.shainmaster.try(:氏名) + " \n " if setsubiyoyaku.shainmaster
  json.title shain + description + " \n " +title

  json.start setsubiyoyaku.try(:開始)
  # json.start '2016-06-03 07:00'
  json.end setsubiyoyaku.try(:終了)
  # json.end '2016-06-03 09:00'
  json.url edit_setsubiyoyaku_path(setsubiyoyaku)
  json.color 'rgb(59, 145, 173)'
  json.textColor 'white'
  json.resourceId setsubiyoyaku.try(:開始).to_date
  # json.hizuke setsubiyoyaku.try(:開始)
end

json.hizukes @hizukes do |hizuke|
  json.id hizuke
  json.hizuke hizuke

end
