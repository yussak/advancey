class ChangeCommentsColumn < ActiveRecord::Migration[6.1]
  def change
    rename_table :comments, :post_comments
    rename_column :post_comments, :comment_content, :content
  end
end
