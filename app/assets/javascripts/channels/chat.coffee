App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log("connected")

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log("disconnected")

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    processNotification()
    if data['type']=="message"
      id = data['conversation_id'];
      chatbox = $("#chatbox_" + id + " .chatboxcontent");
      sender_id = data['user_id'];
      reciever_id = $('meta[name=user-id]').attr("content");
      chatbox.append(data['content']);
      chatbox.scrollTop(chatbox[0].scrollHeight);
      if sender_id != reciever_id
        chatBox.chatWith(id)
        chatbox.children().last().removeClass("self").addClass("other")
        chatbox.scrollTop(chatbox[0].scrollHeight)
        chatBox.notify()    
      