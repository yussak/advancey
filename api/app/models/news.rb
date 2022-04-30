class News < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 200 }

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }
end
