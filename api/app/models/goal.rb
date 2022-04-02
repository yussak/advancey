class Goal < ApplicationRecord
  belongs_to :user
  has_many :goal_comments
end
