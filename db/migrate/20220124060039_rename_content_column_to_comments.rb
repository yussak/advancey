class RenameContentColumnToComments < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :content, :comment_content
  end
end
