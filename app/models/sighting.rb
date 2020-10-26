class Sighting < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  belongs_to :flower
  has_many :likes, dependent: :destroy

  scope :for_flower, ->(id) { where(flower_id: id) }
end
