class Community < ApplicationRecord
  # 関連付け
  has_many :belongings, dependent: :destroy
  has_many :users, through: :belongings
  has_many :messages, dependent: :destroy

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }

  # バリデーション
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 200 }
  validates :message, presence: true, length: { maximum: 100 }
end
