FactoryBot.define do
  factory :sighting do
    user
    flower

    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }

    image do
      Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'images', 'flower.jpg'), 'image/jpg')
    end
  end
end
