class Hike < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :title, :description, :date, :end_date, :location, :price, presence: true
end
