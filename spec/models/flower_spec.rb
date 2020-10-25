require 'rails_helper'

RSpec.describe Flower, type: :model do
  subject { FactoryBot.create(:flower) }

  it { should have_attribute :name }
  it { should have_attribute :description }

  it { should have_many(:sightings).dependent(:destroy) }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).case_insensitive }

  it 'has ActiveStorage attachment' do
    expect(subject.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
