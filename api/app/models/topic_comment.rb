class TopicComment < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :topic

  has_one_attached :image

  def image_url
    url_for(image) if image.attached?
  end

  validates :content, presence: true, length: { maximum: 100 }
  # validates :, presence: true, length: { maximum: 100 }
end
