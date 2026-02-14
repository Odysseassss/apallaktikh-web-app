
class ChatroomsController < ApplicationController
  def create
    @other_user = User.find(params[:user_id])
    name = [current_user.id, @other_user.id].sort.join("-")
    @chatroom = Chatroom.find_or_create_by(name: name)
    
    redirect_to chatroom_path(@chatroom)
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end
end