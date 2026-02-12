Rails.application.config.session_store :cookie_store,
  key: '_ergasia_session',
  same_site: :lax,
  secure: false
