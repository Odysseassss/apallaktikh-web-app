<<<<<<< HEAD
class ChatroomsController < ApplicationController
=======

class ChatroomsController < ApplicationController
  def create
    @other_user = User.find(params[:user_id])
    name = [current_user.id, @other_user.id].sort.join("-")
    @chatroom = Chatroom.find_or_create_by(name: name)
    
    redirect_to chatroom_path(@chatroom)
  end

>>>>>>> ed40c09b3128879fedbfd2efadfb036c98c93b69
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def create
    if params[:user_ids].present?
      recipient_ids = params[:user_ids].map(&:to_i)
    elsif params[:user_id].present?
      recipient_ids = [params[:user_id].to_i]
    else
      redirect_back(fallback_location: root_path, alert: "Παρακαλώ επιλέξτε τουλάχιστον ένα άτομο.") and return
    end

    all_participant_ids = (recipient_ids + [current_user.id]).uniq.sort
    
    chatroom_name = all_participant_ids.join("-")
    
    @chatroom = Chatroom.find_or_create_by(name: chatroom_name)
    
    redirect_to chatroom_path(@chatroom), status: :see_other
  end
end