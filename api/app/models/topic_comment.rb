class TopicComment < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  # validates :topic_comment_content, presence: true, length: { maximum: 100 } # 仮
end
