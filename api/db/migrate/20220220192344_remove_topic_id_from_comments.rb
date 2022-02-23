class RemoveTopicIdFromComments < ActiveRecord::Migration[6.1]
  def change
    remove_reference :comments, :topic, foreign_key: true
  end
end
