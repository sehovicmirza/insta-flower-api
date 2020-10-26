require 'rails_helper'

RSpec.describe Sighting, type: :model do
  subject { FactoryBot.create(:sighting) }

  it { should have_attribute :longitude }
  it { should have_attribute :latitude }

  it { should belong_to :user }
  it { should belong_to :flower }
  it { should have_many(:likes).dependent(:destroy) }

  it 'has ActiveStorage attachment' do
    expect(subject.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
