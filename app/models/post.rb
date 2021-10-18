class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: '適切なフォーマットの画像を追加してください' },
                      size: { less_than: 5.megabytes,
                              message: '5MBより小さいものを追加してください' }
end
