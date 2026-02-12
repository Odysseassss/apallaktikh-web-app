class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  # Έγκυρα status είναι μόνο 'pending' και 'accepted'
  validates :status, inclusion: { in: %w[pending accepted] }
  validates :user_id, uniqueness: { scope: :friend_id } # Όχι διπλά αιτήματα
end