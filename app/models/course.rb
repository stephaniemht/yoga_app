class Course < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :photo

  # Nouveau : un cours a plusieurs créneaux hebdomadaires
  has_many :course_schedules, dependent: :destroy
  accepts_nested_attributes_for :course_schedules, allow_destroy: true

  # Champs de base obligatoires
  validates :title, :location, presence: true

  # Prix décimal
  validates :price,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  # Pour un cours NON récurrent : start_time obligatoire
  validates :start_time,
            presence: true,
            unless: :recurring?

  # Pour un cours récurrent : au moins un créneau (jour + heure)
  validate :recurring_fields_coherent

  # --- helpers ---

  def recurring?
    recurring == true
  end

  def suspended?
    suspended == true
  end

  # Retourne les créneaux triés : lundi → dimanche, puis heure
  def ordered_schedules
    course_schedules.order(:weekday, :time)
  end

  private

  def recurring_fields_coherent
    return unless recurring?

    active_schedules = course_schedules.reject(&:marked_for_destruction?)

    if active_schedules.empty?
      errors.add(:base, "Pour un cours régulier, au moins un créneau (jour + heure) doit être renseigné.")
    end
  end
end
