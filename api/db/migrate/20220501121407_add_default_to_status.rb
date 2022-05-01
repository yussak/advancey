class AddDefaultToStatus < ActiveRecord::Migration[6.1]
  def change
    change_column_default :topics, :solve_status, false
    change_column_default :goals, :achieve_status, false
    change_column_null :topics, :solve_status, false
    change_column_null :goals, :achieve_status, false
  end
end
