class MessagesController < ApplicationController
  before_action :require_user!

  def create
    begin
      @conversation = Conversation.find(params[:conversation_id])
      @message = @conversation.messages.build(message_params)
      @message.user = current_user
      @message.save!
      @path = '/conversations/' + params[:conversation_id]
      reciever_id = current_user.id == @conversation.sender_id ? @conversation.recipient_id : @conversation.sender_id
      notify_to(@conversation.id, reciever_id)
    rescue Exception => e
      puts e
    end
  end

  def destroy
    @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation
      @message = @conversation.messages.find_by(id: params[:id])
      if @message && @message.user == current_user
        @message.destroy
      end  
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
