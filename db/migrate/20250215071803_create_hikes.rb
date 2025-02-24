class CreateHikes < ActiveRecord::Migration[7.2]
  def change
    create_table :hikes do |t|
      t.string :title
      t.text :description
      t.datetime :date
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
