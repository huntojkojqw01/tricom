class ConversationsController < ApplicationController
  before_action :require_user!

  layout false

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    Message.where("conversation_id = ? AND read_at IS ? AND messages.user != ?", @conversation.id, nil, current_user.id)
            .update_all(read_at: Time.zone.now)
    notify_to(@conversation.id)
    render json: { conversation_id: @conversation.id } 
  end
  def update_message
    conversation_id = params[:conversation_id]
    Message.where("conversation_id = ? AND read_at IS ? AND messages.user != ?", conversation_id, nil, session[:user])
            .update_all(read_at: Time.zone.now)
    notify_to(conversation_id)
    respond_to do |format|
      format.json { render json: "OK"}
    end
  end
  def show
    @conversation = Conversation.find_by(id: params[:id])
    @reciever = interlocutor(@conversation)
    @messages = Message.eager_load(:conversation, :user).where(conversation_id: @conversation.id).order(created_at: :asc)    
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end  
end
