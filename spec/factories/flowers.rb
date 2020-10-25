FactoryBot.define do
  factory :flower do
    name { Faker::FunnyName.name }
    description { Faker::Lorem.paragraph }

    image do
      Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'images', 'flower.jpg'), 'image/jpg')
    end
  end
end
