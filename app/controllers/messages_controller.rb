class MessagesController < ApplicationController
  before_filter :require_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user = current_user
    @message.save!
    @path = "/conversations/"+params[:conversation_id]
    @path_notifi = "/messages/new"
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
