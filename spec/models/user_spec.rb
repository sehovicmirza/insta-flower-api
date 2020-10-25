require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.create(:user) }

  it { should have_attribute :email }
  it { should have_attribute :username }
  it { should have_attribute :password_digest }

  it { should have_many(:sightings).dependent(:destroy) }

  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_uniqueness_of(:username).case_insensitive }
end
