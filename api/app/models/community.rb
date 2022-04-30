class Community < ApplicationRecord
  has_many :belongings, dependent: :destroy
  has_many :users, through: :belongings

  has_many :messages, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 200 }

  # デフォルト並び順
  default_scope -> { order(created_at: :desc) }
end
