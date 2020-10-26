require 'rails_helper'

RSpec.describe SightingsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  describe '#index' do
    let(:flowers) { FactoryBot.create_list(:flower, 2) }
    let!(:sightings) { FactoryBot.create_list(:sighting, 3, flower: flowers.first) }
    let!(:another_sightings) { FactoryBot.create_list(:sighting, 2, flower: flowers.second) }

    let(:params) { {} }

    context 'valid data' do
      let(:params) { { flower_id: flowers.first.id } }

      it 'should be successful' do
        get :index, params: params

        expect(response).to be_successful
      end

      it 'should return list of sightings for flower' do
        get :index, params: params

        expected_result = sightings.map do |sighting|
          {
            id: sighting.id,
            latitude: sighting.latitude.to_s,
            longitude: sighting.longitude.to_s,
            user: sighting.user.username,
            image: ActiveStorage::Blob.service.send(:path_for, sighting.image.key),
            likes: sighting.likes
          }
        end

        expect(json_response).to eq(expected_result)
      end
    end

    context 'invalid data' do
      let(:params) { { flower_id: nil } }

      it 'should raise an url generation error' do
        expect do
          get :index, params: params
        end.to raise_error ActionController::UrlGenerationError
      end
    end
  end

  describe '#create' do
    let(:flower) { FactoryBot.create(:flower) }
    let(:image) { fixture_file_upload('images/flower.jpg') }
    let(:user) { FactoryBot.create(:user) }
    let(:token) { JwtService.encode({ user_id: user.id }) }

    let(:headers) { { Authenticable::AUTH_HEADER => "Bearer #{token}" } }
    let(:params) do
      {
        latitude: Faker::Address.latitude,
        longitude: Faker::Address.longitude,
        flower_id: flower.id,
        image: image
      }
    end

    before do
      request.headers.merge!(headers)

      stub_request(:get, ENV['OPENTDB_URL']).to_return(
        lambda do
          {
            status: 200,
            body: {
              response_code: 0,
              results: [
                {
                  category: 'Entertainment: Video Games',
                  type: 'multiple',
                  difficulty: 'easy',
                  question: 'Which of these is NOT a team available in the game Pok&eacute;mon Go?',
                  correct_answer: 'Team Rocket',
                  incorrect_answers: ['Team Instinct', 'Team Valor', 'Team Mysti']
                }
              ]
            }.to_json
          }
        end
      )
    end

    context 'valid data' do
      it 'should be successful' do
        post :create, params: params

        expect(response).to be_successful
      end

      it 'should create correct sighting record' do
        expect do
          post :create, params: params
        end.to change { Sighting.count }
          .by(1)
          .and change { ActiveStorage::Blob.count }.by(2)

        created_sighting = Sighting.last

        expect(created_sighting.user_id).to eq(user.id)
        expect(created_sighting.flower_id).to eq(flower.id)
        expect(created_sighting.latitude.to_s).to eq(params[:latitude].round(6).to_s)
        expect(created_sighting.longitude.to_s).to eq(params[:longitude].round(6).to_s)
        expect(created_sighting.question.keys).to match_array(%w[type category question difficulty correct_answer incorrect_answers])
      end

      it 'should return sighting record' do
        post :create, params: params

        created_sighting = Sighting.last

        expected_result = {
          id: created_sighting.id,
          latitude: params[:latitude].round(6).to_s,
          longitude: params[:longitude].round(6).to_s,
          user: user.username,
          image: ActiveStorage::Blob.service.send(:path_for, created_sighting.image.key),
          likes: created_sighting.likes
        }

        expect(json_response).to eq(expected_result)
      end
    end

    context 'invalid data' do
      context 'unauthenticated request' do
        let(:headers) { {} }

        it 'should return correct error' do
          post :create, params: params

          expect(response).to be_unauthorized
          expect(json_response[:error]).to eq(I18n.t(:unauthenticated_request, scope: %i[errors]))
        end
      end

      context 'missing parameters' do
        let(:params) do
          {
            flower_id: flower.id,
            image: image
          }
        end

        it 'should be unprocessable' do
          post :create, params: params

          expect(response).to be_unprocessable
        end

        it 'should return correct error' do
          post :create, params: params

          expect(json_response[:error]).to eq(I18n.t(:invalid_sighting_data, scope: %i[errors]))
        end
      end
    end
  end

  describe '#destroy' do
    let(:user) { FactoryBot.create(:user) }
    let(:token) { JwtService.encode({ user_id: user.id }) }

    let(:headers) { { Authenticable::AUTH_HEADER => "Bearer #{token}" } }
    let(:params) { { id: sighting.id } }

    before do
      request.headers.merge!(headers)
      delete :destroy, params: params
    end

    context 'valid data' do
      let(:sighting) { FactoryBot.create(:sighting, user: user) }

      it 'should be successful' do
        expect(response).to be_successful
      end

      it 'should destroy sighting' do
        expect { sighting.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'invalid data' do
      let(:second_user) { FactoryBot.create(:user) }
      let(:sighting) { FactoryBot.create(:sighting, user: second_user) }

      it 'should be forbidden' do
        expect(response).to be_forbidden
      end

      it 'should not destroy sighting' do
        expect { sighting.reload }.not_to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
