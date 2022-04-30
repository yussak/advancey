class Topic < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_many :topic_comments, dependent: :destroy

  has_one_attached :image

  def image_url
    url_for(image) if image.attached?
  end

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, length: { maximum: 300 }

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }
end
