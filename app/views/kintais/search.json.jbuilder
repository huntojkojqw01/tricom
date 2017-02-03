json.summary do
  json.sum1 @kintais.sum('実労働時間')
  json.sum2 @kintais.sum('遅刻時間')
  json.sum3 @kintais.sum('普通残業時間')
  json.sum4 @kintais.sum('深夜残業時間')
  json.sum5 @kintais.sum('普通保守時間')
  json.sum6 @kintais.sum('深夜保守時間')
  json.sum7 @kintais.sum('保守携帯回数')
  json.sum8 @yukyu
  json.sum9 @gesshozan

end
