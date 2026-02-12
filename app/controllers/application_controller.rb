class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  allow_browser versions: :modern

  private

end