class Course < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :title, :start_time, :description, :location, :price, presence: true
  # validate :start_time_is_valid_datetime # ici c’est `validate`, au singulier

  def start_time_is_valid_datetime
    unless start_time.is_a?(ActiveSupport::TimeWithZone) || start_time.nil?
      errors.add(:start_time, "doit être une date valide")
    end
  end
end
