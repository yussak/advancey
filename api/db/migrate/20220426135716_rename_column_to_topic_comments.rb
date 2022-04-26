class RenameColumnToTopicComments < ActiveRecord::Migration[6.1]
  def change
    rename_column :topic_comments, :topic_comment_content, :content
  end
end
