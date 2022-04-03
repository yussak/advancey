class AddCommentDateToGoalComments < ActiveRecord::Migration[6.1]
  def change
    add_column :goal_comments, :comment_date, :date, null: false
  end
end
