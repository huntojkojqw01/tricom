json.setsubiyoyakus @setsubiyoyakus do |setsubiyoyaku|
  json.id setsubiyoyaku.id
  json.description "#{ setsubiyoyaku.kaishamaster.try(:会社名) || setsubiyoyaku.相手先 }"
  json.title "#{ setsubiyoyaku.用件 }\n#{ setsubiyoyaku.shainmaster.try(:氏名) } \n "
  json.shain "#{ setsubiyoyaku.shainmaster.try(:氏名) } \n "
  json.yoken setsubiyoyaku.用件
  json.start setsubiyoyaku.開始
  # json.start '2016-06-03 07:00'
  json.end setsubiyoyaku.終了
  # json.end '2016-06-03 09:00'
  json.url edit_setsubiyoyaku_path(setsubiyoyaku)
  json.color 'rgb(59, 145, 173)'
  json.textColor 'white'
  json.resourceId setsubiyoyaku.開始.try(:to_date)
  # json.hizuke setsubiyoyaku.try(:開始)
end

json.hizukes @hizukes do |hizuke|
  json.id hizuke
  json.hizuke hizuke

end
