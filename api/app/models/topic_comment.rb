class TopicComment < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :topic

  has_one_attached :image
  # topic,post,commentに同じものあるので共通化したい
  def image_url
    url_for(image) if image.attached?
  end

  # validates :topic_comment_content, presence: true, length: { maximum: 100 } # 仮
end
