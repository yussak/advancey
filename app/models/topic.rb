class Topic < ApplicationRecord
  belongs_to :user
  has_many :topic_comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 20 }
  validates :content, length: { maximum: 100 } # 仮
end
