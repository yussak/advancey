class Post < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_one_attached :image

  def image_url
    url_for(image) if image.attached?
  end

  # コメント
  has_many :post_comments, dependent: :destroy

  validates :content, presence: true, length: { maximum: 200 }
  # validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
  #                                     message: '適切なフォーマットの画像を追加してください' },
  #                     size: { less_than: 5.megabytes,
  #                             message: '5MBより小さい画像を追加してください' }

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }
end
