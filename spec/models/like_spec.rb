require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { FactoryBot.create(:like) }

  it { should belong_to :user }
  it { should belong_to :sighting }
end
