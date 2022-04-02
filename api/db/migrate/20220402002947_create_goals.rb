class CreateGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.string :content
      t.text :reason
      t.string :todo
      t.integer :period
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
