class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
skip_before_action :verify_authenticity_token, only: [:google_oauth2, :facebook]
  def google_oauth2
    handle_auth "Google"
  end

  def facebook
    handle_auth "Facebook"
  end

  private

  def handle_auth(kind)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = "Success #{kind}!"
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.auth_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end