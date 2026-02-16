class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  validates :name, presence: { message: "can't be blank" }

         
  has_many :posts, dependent: :destroy
  has_many :contacts, dependent: :destroy

  has_many :received_requests, class_name: "Contact", foreign_key: "friend_id", dependent: :destroy

  def contact_with?(other_user)
    contacts.exists?(friend: other_user) || received_requests.exists?(user: other_user)
  end

  def self.from_omniauth(auth)
      user = find_or_initialize_by(email: auth.info.email)

      user.provider = auth.provider
      user.uid = auth.uid
      user.name ||= auth.info.name

      if user.new_record?
        user.password = Devise.friendly_token[0, 20]
      end

      user.save!
      user
  end
      def contact_status_with(other_user)
      outbound = contacts.find_by(friend_id: other_user.id)
      return 'accepted' if outbound&.status == 'accepted'
      return 'pending_sent' if outbound&.status == 'pending'
      inbound = Contact.find_by(user_id: other_user.id, friend_id: self.id)
      return 'accepted' if inbound&.status == 'accepted'
      return 'pending_received' if inbound&.status == 'pending'

      'none'
   end
end