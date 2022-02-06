class Post < ApplicationRecord
  belongs_to :user
  # has_one_attached :image

  # # いいね機能
  # has_many :likes, dependent: :destroy
  # has_many :users, through: :likes

  # # 投稿 コメント
  # has_many :comments, dependent: :destroy

  # default_scope -> { order(created_at: :desc) }
  # validates :user_id, presence: true
  # # validates :content, presence: true, length: { maximum: 140 }
  # validates :content, presence: true, length: { maximum: 500 } # 仮
  # validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
  #                                     message: '適切なフォーマットの画像を追加してください' },
  #                     size: { less_than: 5.megabytes,
  #                             message: '5MBより小さい画像を追加してください' }
  # validates :url, allow_blank: true, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/

  # # 画像サイズの上限設定
  # def display_image
  #   image.variant(resize_to_limit: [400, 400])
  # end
end
