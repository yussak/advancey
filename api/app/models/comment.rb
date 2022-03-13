class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :post

  has_one_attached :image
  # topic,postに同じものあるので共通化したい
  def image_url
    url_for(image) if image.attached?
  end
  # validates :comment_content, presence: true, length: { maximum: 140 }
end
