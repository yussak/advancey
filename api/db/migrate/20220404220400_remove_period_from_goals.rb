class RemovePeriodFromGoals < ActiveRecord::Migration[6.1]
  def change
    remove_column :goals, :period, :integer
  end
end
