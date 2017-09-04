class MessagesController < ApplicationController
  before_filter :require_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user = current_user
    if @message.save!  
      if current_user.id==@conversation.sender_id
        ActionCable.server.broadcast "user_#{@conversation.recipient_id}",
          {
            type: "message",
            conversation_id: params[:conversation_id],
            user_id: current_user.id,
            content: ApplicationController.renderer.render(partial: 'messages/message', locals: { message: @message }) 
          }
      else
        ActionCable.server.broadcast "user_#{@conversation.sender_id}",
          {
            type: "message",
            conversation_id: params[:conversation_id],
            user_id: current_user.id,
            content: ApplicationController.renderer.render(partial: 'messages/message', locals: { message: @message }) 
          }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
