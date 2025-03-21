class ChangeTimeColumnTypeInCourses < ActiveRecord::Migration[7.2]
  def change
    change_column :courses, :time, 'time USING time::time'
  end
end
