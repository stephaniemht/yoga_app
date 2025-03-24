class ChangeStartTimeTypeInCourses < ActiveRecord::Migration[7.2]
  def change
    change_column :courses, :start_time, "timestamp without time zone USING (CURRENT_DATE + start_time)"
  end
end
