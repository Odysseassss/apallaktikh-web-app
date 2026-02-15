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
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.name = auth.info.name
  end
end
end