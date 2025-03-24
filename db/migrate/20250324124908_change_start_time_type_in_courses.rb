class ChangeStartTimeTypeInCourses < ActiveRecord::Migration[7.2]
  def change
    change_column :courses, :start_time, :datetime
  end
end
