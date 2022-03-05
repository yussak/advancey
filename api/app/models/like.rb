class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  scope :filter_by_post, ->(post_id) { where(post_id: post_id) if post_id }
end
