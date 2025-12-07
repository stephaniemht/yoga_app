class Course < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :photo

  # Cours récurrents : plusieurs créneaux jour + heure
  has_many :course_schedules, dependent: :destroy

  accepts_nested_attributes_for :course_schedules,
                                allow_destroy: true,
                                reject_if: proc { |attrs|
                                  attrs["weekday"].blank? && attrs["time"].blank?
                                }

  # Champs de base obligatoires
  validates :title, :location, presence: true

  # Prix : décimal, mais pas obligatoire
  validates :price,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  # Pour un cours NON récurrent : start_time obligatoire
  validates :start_time,
            presence: true,
            unless: :recurring?

  # Pour un cours récurrent : on vérifie qu'il y ait au moins un créneau
  validate :recurring_schedules_coherent

  # --- helpers ---

  def recurring?
    recurring == true
  end

  private

  def recurring_schedules_coherent
    return unless recurring?

    valides = course_schedules.reject do |cs|
      cs.marked_for_destruction? ||
        (cs.weekday.blank? && cs.time.blank?)
    end

    if valides.empty?
      errors.add(:base, "Pour un cours régulier, ajoute au moins un créneau (jour + heure).")
    end
  end
end
