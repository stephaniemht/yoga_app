class Hike < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many_attached :carousel_photos

  validates :title, :description, :date, :end_date, :location, :price, presence: true
end
