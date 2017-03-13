json.notification do
  json.kairanCount @kairans.count
  json.dengonCount @dengons.count
end

json.my_kairans @kairans do |kairan|
  json.item "<li><a class=\"glyphicon glyphicon-envelope icon-left\" href=\"/kairans?locale=ja&search="+kairan.内容+" \"> "+ kairan.内容+"</a></li>" if kairan.内容
end

json.my_dengons @dengons do |dengon|
  json.item "<li><a class=\"glyphicon glyphicon-comment icon-left\" href=\"/dengons?locale=ja&search="+dengon.伝言内容+" \"> "+ dengon.伝言内容+"</a></li>" if dengon.伝言内容
end