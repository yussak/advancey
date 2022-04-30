class AddColumnToGoals < ActiveRecord::Migration[6.1]
  def change
    add_column :goals, :achieve_status, :boolean
  end
end
