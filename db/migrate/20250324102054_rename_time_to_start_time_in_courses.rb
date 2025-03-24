class RenameTimeToStartTimeInCourses < ActiveRecord::Migration[7.2]
  def change
    rename_column :courses, :time, :start_time
  end
end
