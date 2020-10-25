class Flower < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :sightings, dependent: :destroy
end
