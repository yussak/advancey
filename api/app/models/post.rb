class Post < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_one_attached :image

  def image_url
    url_for(image) if image.attached?
  end

  # # いいね機能
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  # # 投稿 コメント
  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { maximum: 200 }
  # validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
  #                                     message: '適切なフォーマットの画像を追加してください' },
  #                     size: { less_than: 5.megabytes,
  #                             message: '5MBより小さい画像を追加してください' }
end
