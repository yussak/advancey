class AddColumnPrivacyToGoals < ActiveRecord::Migration[6.1]
  def change
    add_column :goals, :privacy, :boolean, default: false
  end
end
