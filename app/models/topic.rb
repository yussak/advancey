class Topic < ApplicationRecord
  belongs_to :user
  has_many :topic_comments
end
