class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def create
    # 1. Έλεγχος αν ήρθε λίστα ατόμων (Modal) ή ένα άτομο (Κουμπί)
    if params[:user_ids].present?
      recipient_ids = params[:user_ids].map(&:to_i)
    elsif params[:user_id].present?
      recipient_ids = [params[:user_id].to_i]
    else
      redirect_back(fallback_location: root_path, alert: "Παρακαλώ επιλέξτε τουλάχιστον ένα άτομο.") and return
    end

    # 2. Προσθέτουμε τον τρέχοντα χρήστη και ταξινομούμε
    all_participant_ids = (recipient_ids + [current_user.id]).uniq.sort
    
    # 3. Δημιουργούμε το όνομα (π.χ. "1-2-5")
    chatroom_name = all_participant_ids.join("-")
    
    # 4. Βρίσκουμε ή φτιάχνουμε το δωμάτιο
    @chatroom = Chatroom.find_or_create_by(name: chatroom_name)
    
    # 5. Ανακατεύθυνση στο δωμάτιο με status: :see_other (Απαραίτητο για Turbo!)
    redirect_to chatroom_path(@chatroom), status: :see_other
  end
end