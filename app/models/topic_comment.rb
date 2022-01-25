class TopicComment < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :topic_comment_content, presence: true
  # validates :title, presence: true, length: { maximum: 20 }
end
