class ConversationsController < ApplicationController
  before_filter :require_user!

  layout false

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    @messages = Message.all.where(conversation_id: @conversation.id,read_at: nil)
    .joins(:user).where("担当者マスタ.担当者コード!= ?",current_user.id)
    .update_all(read_at: Time.zone.now)
    @mess = Message.all.where(conversation_id: (Conversation.involving(current_user).map(&:id)),read_at: nil)
    .joins(:user).where("担当者マスタ.担当者コード!= ?",current_user.id).order(created_at: :desc)
    messageCount = @mess.count
    items = ''

    if messageCount > 0
      @mess.each do |message|
        naiyou = message.body.length > 12 ? '#{message.body[0...12]}...' : message.body
        items = items + '<li><a class=\" glyphicon glyphicon-comment icon-left start-conversation \" data-sid=\"'+message.conversation.sender_id+'\" data-rip = \"'+ message.conversation.recipient_id+'\" href=\"#\"> kkk'+ message.user.name+': gg'+naiyou+'</a></li>' if message.body
      end
    end

    PrivatePub.publish_to("/messages/"+current_user.id,"if(#{messageCount} > 0){
                if($('.glyphicon-bell').hasClass('text-red') == false){
                    $('.glyphicon-bell').addClass('text-red');
                    $('.message-count').addClass('text-red');
                }
                $('.message-count').text(#{messageCount})
                $('.message-item').css('display','')
                $('.message-item').html(\'"+items+"\')
            }else{
                if($('.glyphicon-bell').hasClass('text-red')){
                  $('.glyphicon-bell').removeClass('text-red');
                  $('.message-count').removeClass('text-red');
                }
                $('.message-item').css('display','none')
                $('.message-count').text('')
                $('.message-item').html('')
            }")

    render json: { conversation_id: @conversation.id }
  end
  def update_message
    conversation_id = params[:conversation_id]
    @messages = Message.all.where(conversation_id: conversation_id,read_at: nil)
    .joins(:user).where("担当者マスタ.担当者コード!= ?",current_user.id)
    .update_all(read_at: Time.zone.now)
    @mess = Message.all.where(conversation_id: (Conversation.involving(current_user).map(&:id)),read_at: nil)
    .joins(:user).where("担当者マスタ.担当者コード!= ?",current_user.id).order(created_at: :desc)
    messageCount = @mess.count
    items = ''

    if messageCount > 0
      @mess.each do |message|
        naiyou = message.body.length > 12 ? '#{message.body[0...12]}...' : message.body
        items = items + '<li><a class=\" glyphicon glyphicon-comment icon-left start-conversation \" data-sid=\"'+message.conversation.sender_id+'\" data-rip = \"'+ message.conversation.recipient_id+'\" href=\"#\"> kkk'+ message.user.name+': gg'+naiyou+'</a></li>' if message.body
      end
    end

    PrivatePub.publish_to("/messages/"+current_user.id,"if(#{messageCount} > 0){
                if($('.glyphicon-bell').hasClass('text-red') == false){
                    $('.glyphicon-bell').addClass('text-red');
                    $('.message-count').addClass('text-red');
                }
                $('.message-count').text(#{messageCount})
                $('.message-item').css('display','')
                $('.message-item').html(\'"+items+"\')
            }else{
                if($('.glyphicon-bell').hasClass('text-red')){
                  $('.glyphicon-bell').removeClass('text-red');
                  $('.message-count').removeClass('text-red');
                }
                $('.message-item').css('display','none')
                $('.message-count').text('')
                $('.message-item').html('')
            }")
    respond_to do |format|
      format.json { render json: "OK"}
    end
  end
  def show
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages.order(created_at: :asc)
    @message = Message.new
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end
end
