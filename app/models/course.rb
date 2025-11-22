class Course < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :photo

  # Champs de base obligatoires
  validates :title, :location, presence: true

  # Description conseillée mais pas bloquante (si tu veux la rendre obligatoire, on pourra)
  # validates :description, presence: true

  # Prix : décimal, mais pas obligatoire
  validates :price,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  # Pour un cours NON récurrent : start_time obligatoire
  validates :start_time,
            presence: true,
            unless: :recurring?

  # Pour un cours récurrent : on vérifie qu'il y a au moins un jour + une heure
  validate :recurring_fields_coherent

  # --- helpers ---

  def recurring?
    recurring == true
  end

  private

  def recurring_fields_coherent
    return unless recurring?

    # Au moins jour 1 + heure 1
    if day_1.blank? || time_1.blank?
      errors.add(:base, "Pour un cours régulier, au moins un premier jour et une heure doivent être renseignés.")
    end

    # Si un 2ᵉ jour est choisi, il doit avoir une heure
    if day_2.present? && time_2.blank?
      errors.add(:time_2, "doit être renseignée si un deuxième jour est sélectionné.")
    end
  end
end
