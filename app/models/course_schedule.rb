class CourseSchedule < ApplicationRecord
  belongs_to :course

  # 1 = Lundi, 7 = Dimanche
  validates :weekday,
            presence: true,
            inclusion: { in: 1..7 }

  validates :time, presence: true

  DAYS_FR = {
    1 => "Lundi",
    2 => "Mardi",
    3 => "Mercredi",
    4 => "Jeudi",
    5 => "Vendredi",
    6 => "Samedi",
    7 => "Dimanche"
  }.freeze

  # Pour afficher facilement : schedule.weekday_name
  def weekday_name
    DAYS_FR[weekday]
  end
end
