class RenameActionColumnToPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :action, :tag
  end
end
