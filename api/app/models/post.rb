class Post < ApplicationRecord
  include Rails.application.routes.url_helpers

  # 画像
  has_one_attached :image
  def image_url
    url_for(image) if image.attached?
  end

  # 関連付け
  belongs_to :user
  has_many :post_comments, dependent: :destroy

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }

  # バリデーション
  validates :content, presence: true, length: { maximum: 200 }
end
