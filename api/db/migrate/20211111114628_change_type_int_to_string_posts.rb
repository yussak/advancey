class ChangeTypeIntToStringPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :action, :string
  end
end
