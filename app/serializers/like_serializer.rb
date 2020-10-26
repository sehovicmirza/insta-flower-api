class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :sighting_id
end
