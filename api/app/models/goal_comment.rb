class GoalComment < ApplicationRecord
  belongs_to :goal
  belongs_to :user

  # バリデーション
  validates :content, presence: true, length: { maximum: 200 }
  validates :comment_date, presence: true
end
