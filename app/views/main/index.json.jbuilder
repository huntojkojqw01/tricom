json.notification do
  json.kairanCount @kairans.count
  json.dengonCount @dengons.count
end

json.my_kairans @kairans do |kairan|
  naiyou = kairan.内容.length > 14 ? "#{kairan.内容[0...14]}..." : kairan.内容
  json.item "<li><a class=\"glyphicon glyphicon-envelope icon-left\" href=\"/kairans?locale=ja&search="+kairan.内容+" \"> "+ naiyou+"</a></li>" if kairan.内容
end

json.my_dengons @dengons do |dengon|
  naiyou = dengon.伝言内容.length > 14 ? "#{dengon.伝言内容[0...14]}..." : dengon.伝言内容
  json.item "<li><a class=\"glyphicon glyphicon-comment icon-left\" href=\"/dengons?locale=ja&search="+dengon.伝言内容+" \"> "+ naiyou+"</a></li>" if dengon.伝言内容
end