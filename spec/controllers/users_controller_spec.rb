require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:params) { {} }

  describe '#create' do
    context 'valid data' do
      let(:params) do
        {
          email: Faker::Internet.unique.email,
          username: Faker::Internet.unique.username,
          password: Faker::Crypto.md5
        }
      end

      it 'should be successfull' do
        post :create, params: params

        expect(response).to be_successful
      end

      it 'should create new user' do
        expect do
          post :create, params: params
        end.to change { User.count }.by(1)

        created_user = User.last

        expect(created_user.email).to eq(params[:email])
        expect(created_user.username).to eq(params[:username])
        expect(created_user.authenticate(params[:password])).to be_truthy
      end
    end

    context 'invalid data' do
      let(:params) do
        {
          email: 'invalid input',
          username: Faker::Internet.unique.username,
          password: Faker::Crypto.md5
        }
      end

      it 'should be unprocessible' do
        post :create, params: params

        expect(response).to be_unprocessable
        expect(json_response[:error]).to eq(I18n.t(:invalid_input_data, scope: %i[errors]))
      end

      it 'should not create new user' do
        expect do
          post :create, params: params
        end.not_to change { User.count }
      end
    end
  end

  describe '#login' do
    let(:decoded_token) { JwtService.decode(json_response[:token]) }

    context 'valid data' do
      let(:password) { Faker::Crypto.md5 }
      let(:user) { FactoryBot.create(:user, password: password) }
      let(:params) { { username: user.username, password: password } }

      it 'should be successfull' do
        post :login, params: params

        expect(response).to be_successful
      end

      it 'should return valid JWT token' do
        post :login, params: params

        expect(decoded_token.first['user_id']).to eq(user.id)
        expect(decoded_token.second['typ']).to eq('JWT')
        expect(decoded_token.second['alg']).to eq(JwtService::ALGORITHM)
      end
    end

    context 'invalid data' do
      let(:password) { Faker::Crypto.md5 }
      let(:user) { FactoryBot.create(:user, password: password) }
      let(:params) { { username: user.username, password: Faker::Crypto.md5 } }

      it 'should be unauthorized' do
        post :login, params: params

        expect(response).to be_unauthorized
      end
    end
  end
end
