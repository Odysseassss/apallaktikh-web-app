class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]
         
  has_many :posts, dependent: :destroy
  has_many :contacts, dependent: :destroy

  has_many :received_requests, class_name: "Contact", foreign_key: "friend_id", dependent: :destroy

  def contact_with?(other_user)
    contacts.exists?(friend: other_user) || received_requests.exists?(user: other_user)
  end

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_initialize

    user.provider = auth.provider
    user.uid = auth.uid
    user.name ||= auth.info.name 
    if user.new_record?
      user.password = Devise.friendly_token[0, 20]
    end
    user.save
    user
  end
end