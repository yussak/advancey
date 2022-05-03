class Topic < ApplicationRecord
  include Rails.application.routes.url_helpers

  # 画像
  has_one_attached :image
  def image_url
    url_for(image) if image.attached?
  end

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }

  # 関連付け
  belongs_to :user
  has_many :topic_comments, dependent: :destroy

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, length: { maximum: 300 }
end
