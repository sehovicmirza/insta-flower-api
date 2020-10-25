require 'rails_helper'

RSpec.describe FlowersController, type: :controller do
  let!(:flowers) { FactoryBot.create_list(:flower, 3) }
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  describe '#index' do
    before { get :index }

    it 'should return list of flowers' do
      expected_result = flowers.map do |flower|
        {
          id: flower.id,
          name: flower.name,
          description: flower.description,
          image: ActiveStorage::Blob.service.send(:path_for, flower.image.key)
        }
      end

      expect(json_response).to eq(expected_result)
    end
  end
end
