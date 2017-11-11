require 'rails_helper'

RSpec.describe 'Users API' do
  describe '#create' do
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
      before { post '/users', params: valid_attrs }

      it 'returns a new user' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['username']).not_to be_nil
      end

      it 'returns response with :created status' do
        expect(response).to have_http_status(201)
      end

    end

    context 'when invalid attributes' do
      before { post '/users', params: invalid_attrs }

      xit 'returns response with :unprocessable_entity status' do
        # TODO Implement
      end

      xit 'returns error message' do
        # TODO Implement
      end
    end
  end
end
