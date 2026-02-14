class ContactsController < ApplicationController
  before_action :authenticate_user!

  def create
    # Βρίσκουμε τον χρήστη στον οποίο θέλουμε να στείλουμε αίτημα
    @friend = User.find(params[:friend_id])

    # Δημιουργούμε το αίτημα
    @contact = current_user.contacts.build(friend: @friend, status: 'pending')

    if @contact.save
      redirect_back fallback_location: root_path, notice: "Friend request sent to #{@friend.email}!"
    else
      # Αν αποτύχει, μας δείχνει το γιατί (π.χ. έχετε ήδη στείλει)
      redirect_back fallback_location: root_path, alert: "Error: #{@contact.errors.full_messages.to_sentence}"
    end
  end

  # Αποδοχή αιτήματος
  def update
    @contact = Contact.find(params[:id])
    
    # Ενημερώνω το αίτημα σε 'accepted'
    @contact.update(status: 'accepted')
    
    # Δημιουργώ την αντιστροφη εγγραφή ώστε να είμαι κι εγώ στη λίστα του άλλου
    Contact.create(user_id: current_user.id, friend_id: @contact.user_id, status: 'accepted')

    redirect_back fallback_location: root_path, notice: "Request has been accepted!"
  end

  # Απόρριψη ή Διαγραφή
  def destroy
    @contact = Contact.find(params[:id])
    
    # Αν είμαστε φίλοι (accepted), πρέπει να σβήσουμε και τις δύο εγγραφές
    if @contact.status == 'accepted'
      # Βρες την αντίστροφη εγγραφή
      reverse_contact = Contact.find_by(user: @contact.friend, friend: @contact.user)
      reverse_contact&.destroy
    end
    
    @contact.destroy
    redirect_back fallback_location: root_path, notice: "Contact has been removed/rejected."
  end
end