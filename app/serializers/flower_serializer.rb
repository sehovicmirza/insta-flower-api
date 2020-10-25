class FlowerSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image

  def image
    if Rails.env.development? || Rails.env.test?
      ActiveStorage::Blob.service.send(:path_for, object.image.key)
    else
      object.image.service_url
    end
  end
end
