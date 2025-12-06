class CreateCourseSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :course_schedules do |t|
      t.integer :weekday, null: false
      t.time :time, null: false
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
