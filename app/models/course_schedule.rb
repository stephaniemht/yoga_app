class CourseSchedule < ApplicationRecord
  belongs_to :course

  validates :weekday, presence: true
  validates :time, presence: true
end
