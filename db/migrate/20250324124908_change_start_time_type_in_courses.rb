class ChangeStartTimeTypeInCourses < ActiveRecord::Migration[7.2]
  def change
    change_column :courses, :start_time, 'timestamp USING (CURRENT_DATE + start_time)'
  end
end
