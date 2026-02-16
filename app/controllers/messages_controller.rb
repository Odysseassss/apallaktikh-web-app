class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    content = message_params[:content].to_s.strip

    return if content.empty?

    @message = @chatroom.messages.new(content: content)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chatroom_path(@chatroom) }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
