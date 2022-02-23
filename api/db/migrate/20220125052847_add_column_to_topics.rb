class AddColumnToTopics < ActiveRecord::Migration[6.1]
  def change
    add_column :topics, :solve_status, :boolean
  end
end
