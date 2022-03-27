class AddMessageToCommunities < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :message, :text
  end
end
