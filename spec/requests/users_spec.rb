require 'rails_helper'

RSpec.describe 'Users API' do
  describe '#create' do
    let(:user) { create(:user) }
    let(:header) { { 'Authorization' => JwtHandler.encode(user_id: user.id) } }
    let(:valid_attrs) do
      {
        data: {
          attributes: attributes_for(:user)
        }
      }
    end.to_json
    let(:invalid_attrs) do
      {
        data: {
          attributes: {
            username: '',
            password: 'pa33word'
          }
        }
      }
    end.to_json

    context 'when valid attributes' do
      before { post '/users', params: valid_attrs, headers: header }

      it 'returns a new user' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['username']).not_to be_nil
      end

      it 'returns response with :created status' do
        expect(response).to have_http_status(201)
      end

    end

    context 'when invalid attributes' do
      before { post '/users', params: invalid_attrs, headers: header }

      it 'returns error object' do
        response_json = JSON.parse(response.body)
        expect(response_json['errors']).not_to be_empty
      end

      it 'returns response with status unprocessable_entity' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
