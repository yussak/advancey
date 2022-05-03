class News < ApplicationRecord
  # 関連付け
  belongs_to :user

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }

  # バリデーション
  validates :content, presence: true, length: { maximum: 200 }
end
