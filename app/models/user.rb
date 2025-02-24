class User < ApplicationRecord
  has_many :courses, dependent: :destroy
  has_many :hikes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attribute :admin, :boolean, default: false
end
