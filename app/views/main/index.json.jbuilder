json.notification do
  json.kairanCount @kairans.count
  json.dengonCount @dengons.count
  json.messageCount @messages.count
  json.totalCount @kairans.count+@dengons.count+@messages.count
end

json.my_kairans @kairans do |kairan|
  naiyou = kairan.内容.length > 12 ? "#{kairan.内容[0...12]}..." : kairan.内容
  json.item "<li><a class=\"glyphicon glyphicon-envelope icon-left\" href=\"/kairans?locale=ja&search="+kairan.内容+" \"> "+ naiyou+"</a></li>" if kairan.内容
end

json.my_dengons @dengons do |dengon|
  naiyou = dengon.伝言内容.length > 12 ? "#{dengon.伝言内容[0...12]}..." : dengon.伝言内容
  json.item "<li><a class=\"glyphicon glyphicon-comment icon-left\" href=\"/dengons?locale=ja&search="+dengon.伝言内容+" \"> "+ naiyou+"</a></li>" if dengon.伝言内容
end

json.my_messages @messages do |message|
  naiyou = message.body.length > 12 ? "#{message.body[0...12]}..." : message.body
  json.item "<li><a class=\" fa fa-wechat icon-left start-conversation \" data-sid=\""+message.conversation.sender_id+"\" data-rip = \""+ message.conversation.recipient_id+"\" href=\"#\">&nbsp;&nbsp;&nbsp;"+ message.user.name+": "+naiyou+"</a></li>" if message.body
end