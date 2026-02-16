class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:query].present?
      @users = User.where.not(id: current_user.id)
                   .where("name LIKE ? OR email LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%").limit(5)
    else
      @users = []
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    # Αν υπάρχει id, βρίσκουμε τον συγκεκριμένο χρήστη, αλλιώς τον εαυτό μας (profile)
    @user = params[:id] ? User.find(params[:id]) : current_user
    
    # Φέρνουμε τα posts του χρήστη (υποθέτοντας ότι το μοντέλο User has_many :posts)
    @posts = @user.posts.order(created_at: :desc)
    
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end
end