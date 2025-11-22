class Course < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :title, :description, :location, :price, presence: true
  validates :start_time, presence: true, unless: :recurring?

  # pour un cours récurrent : on exige au moins un jour + une heure
  validate :recurring_fields_present_if_recurring

  private

  def recurring_fields_present_if_recurring
    return unless recurring?

    if day_1.blank? || time_1.blank?
      errors.add(:base, "Pour un cours régulier, au moins un jour et une heure doivent être renseignés.")
    end
  end
  def start_time_is_valid_datetime
    unless start_time.is_a?(ActiveSupport::TimeWithZone) || start_time.nil?
      errors.add(:start_time, "doit être une date valide")
    end
  end
end
