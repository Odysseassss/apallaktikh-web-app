class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, presence: true
  validates :body, presence: true

  def self.search(query)
    if query.present?
      # Ψάχνει στον τίτλο Ή στο σώμα του κειμένου
      where("title LIKE ? OR body LIKE ?", "%#{query}%", "%#{query}%")
    else
      all
    end
  end
end