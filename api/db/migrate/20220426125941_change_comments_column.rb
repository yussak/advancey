class ChangeCommentsColumn < ActiveRecord::Migration[6.1]
  def change
    rename_table :comments, :post_comments
    rename_column :comments, :comment_content, :content
  end
end
