class SightingSerializer < ActiveModel::Serializer
  attributes :id, :longitude, :latitude, :image, :user

  def image
    if Rails.env.development? || Rails.env.test?
      ActiveStorage::Blob.service.send(:path_for, object.image.key)
    else
      object.image.service_url
    end
  end

  def user
    object.user.username
  end
end
