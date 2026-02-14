class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_active_chats
  
  protect_from_forgery with: :exception, prepend: true
  allow_browser versions: :modern

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_active_chats
    if user_signed_in?
      # Χρησιμοποιούμε Arel.sql() για να πούμε στο Rails ότι το string είναι έμπιστο
      @active_chatrooms = Chatroom.where("chatrooms.name LIKE ?", "%#{current_user.id}%")
                                  .left_joins(:messages)
                                  .group("chatrooms.id")
                                  .order(Arel.sql("MAX(messages.created_at) DESC NULLS LAST"))
    end
  end
end