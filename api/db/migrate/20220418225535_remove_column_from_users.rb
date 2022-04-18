class RemoveColumnFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :password_digest
    remove_column :users, :remember_digest
    remove_column :users, :reset_digest
    remove_column :users, :reset_sent_at
  end
end
