class ContactsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friend = User.find(params[:friend_id])
    
    existing_contact = Contact.where(user: current_user, friend: @friend)
                              .or(Contact.where(user: @friend, friend: current_user))
                              .first

    if existing_contact
      message = existing_contact.status == 'pending' && existing_contact.friend == current_user ? 
                "Αυτός ο χρήστης σου έχει ήδη στείλει αίτημα!" : "Υπάρχει ήδη μια σύνδεση."
      redirect_back fallback_location: root_path, alert: message
      return
    end

    @contact = current_user.contacts.build(friend: @friend, status: 'pending')
    
    if @contact.save
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Request sent!" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "contact_status_#{params[:post_id]}",
            partial: "posts/contact_button_status",
            locals: { post: Post.find(params[:post_id]), current_user: current_user }
          )
        end
      end
    else
      redirect_back fallback_location: root_path, alert: "Something went wrong."
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @target_user_id = @contact.user_id == current_user.id ? @contact.friend_id : @contact.user_id
    
    if @contact.status == 'accepted'
      reverse_contact = Contact.find_by(user: @contact.friend, friend: @contact.user)
      reverse_contact&.destroy
    end
    
    @contact.destroy

    respond_to do |format|
      format.turbo_stream # <--- ΓΙΑ ΝΑ ΜΗΝ ΚΛΕΙΝΕΙ Η ΜΠΑΡΑ ΟΤΑΝ ΣΒΗΝΕΙΣ ΚΑΠΟΙΟΝ
      format.html { redirect_back fallback_location: root_path, notice: "Removed." }
    end
  end

  # Αποδοχή αιτήματος
  def update
      @contact = Contact.find(params[:id])
  
      # Χρησιμοποιούμε transaction για σιγουριά ότι θα γίνουν και τα δύο ή τίποτα
      Contact.transaction do
        @contact.update!(status: 'accepted')
        Contact.find_or_create_by!(user_id: current_user.id, friend_id: @contact.user_id) do |c|
          c.status = 'accepted'
        end
      end

      respond_to do |format|
        format.turbo_stream # Αυτό θα ψάξει το αρχείο update.turbo_stream.erb
        format.html { redirect_back fallback_location: root_path, notice: "Accepted!" }
      end
  rescue ActiveRecord::RecordInvalid
      redirect_back fallback_location: root_path, alert: "Something went wrong."
  end
end