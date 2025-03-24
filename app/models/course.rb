class Course < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  # Si la colonne :date n’existe plus, retire-la des validations
  validates :title, :start_time, :description, :location, :price, presence: true

  # S’il n’y a plus de colonne `date`, supprime aussi la validation sur `:date`
  # et assure-toi de ne plus faire Course.order(date: :asc)
end

