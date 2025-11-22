class AddRecurrenceToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :recurring, :boolean, default: false, null: false
    add_column :courses, :day_1, :integer
    add_column :courses, :time_1, :time
    add_column :courses, :day_2, :integer
    add_column :courses, :time_2, :time
    add_column :courses, :suspended, :boolean, default: false, null: false
  end
end
