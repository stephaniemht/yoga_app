class Course < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :title, :start_time, :description, :location, :price, presence: true

  def start_time
    raw = super
    return nil if raw.nil?
    return raw if raw.is_a?(Time) || raw.is_a?(DateTime) || raw.is_a?(ActiveSupport::TimeWithZone)
    Time.zone.parse(raw.to_s) rescue nil
  end
end
