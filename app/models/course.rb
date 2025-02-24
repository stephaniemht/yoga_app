class Course < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :title, :description, :date, :location, :price, presence: true
end
