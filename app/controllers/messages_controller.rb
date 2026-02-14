class MessagesController < ApplicationController
  def create
      @chatroom = Chatroom.find(params[:chatroom_id])
      @message = @chatroom.messages.new(message_params)
      @message.user = current_user

      if @message.save
        respond_to do |format|
          format.turbo_stream  # θα χρησιμοποιήσει create.turbo_stream.erb
          format.html { redirect_to chatroom_path(@chatroom) } # fallback για browsers χωρίς Turbo
        end
      else
        render "chatrooms/show", status: :unprocessable_entity
      end
  end


  private

  def message_params
    params.require(:message).permit(:content)
  end
end
