# class Topic < ApplicationRecord
#   belongs_to :user
#   has_many :topic_comments, dependent: :destroy

#   validates :title, presence: true, length: { maximum: 100 }
#   validates :content, length: { maximum: 300 } # 仮
# end
