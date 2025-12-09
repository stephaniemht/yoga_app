class Presentation < ApplicationRecord
  has_one_attached :photo
  validates :content, presence: true
end
