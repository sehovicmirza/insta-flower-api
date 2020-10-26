require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  describe '#create' do
    let(:sighting) { FactoryBot.create(:sighting) }
    let(:user) { FactoryBot.create(:user) }
    let(:token) { JwtService.encode({ user_id: user.id }) }

    let(:headers) { { Authenticable::AUTH_HEADER => "Bearer #{token}" } }
    let(:params) { { sighting_id: sighting.id } }

    before { request.headers.merge!(headers) }

    context 'valid data' do
      it 'should be successful' do
        post :create, params: params

        expect(response).to be_successful
      end

      it 'should create correct like record' do
        expect do
          post :create, params: params
        end.to change { Like.count }.by(1)

        created_like = Like.last

        expect(created_like.user_id).to eq(user.id)
        expect(created_like.sighting_id).to eq(sighting.id)
      end

      it 'should return like record' do
        post :create, params: params

        created_like = Like.last

        expected_result = {
          id: created_like.id,
          user_id: user.id,
          sighting_id: sighting.id
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
        let(:params) { {} }

        it 'should be unprocessable' do
          post :create, params: params

          expect(response).to be_unprocessable
        end

        it 'should return correct error' do
          post :create, params: params

          expect(json_response[:error]).to eq(I18n.t(:invalid_like_data, scope: %i[errors]))
        end
      end
    end
  end

  describe '#destroy' do
    let(:user) { FactoryBot.create(:user) }
    let(:token) { JwtService.encode({ user_id: user.id }) }

    let(:headers) { { Authenticable::AUTH_HEADER => "Bearer #{token}" } }
    let(:params) { { id: like.id } }

    before do
      request.headers.merge!(headers)
      delete :destroy, params: params
    end

    context 'valid data' do
      let(:like) { FactoryBot.create(:like, user: user) }

      it 'should be successful' do
        expect(response).to be_successful
      end

      it 'should destroy like' do
        expect { like.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'invalid data' do
      let(:second_user) { FactoryBot.create(:user) }
      let(:like) { FactoryBot.create(:like, user: second_user) }

      it 'should be forbidden' do
        expect(response).to be_forbidden
      end

      it 'should not destroy sighting' do
        expect { like.reload }.not_to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
