class Goal < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_many :goal_comments

  has_one_attached :image

  def image_url
    url_for(image) if image.attached?
  end
end
