require 'rails_helper'

RSpec.describe 'Authentication API' do
  let!(:user) { create(:user, username: 'john', password: 'pa33word') }

  describe '#create' do
    context 'when valid credentials' do
      before { post '/token',
        params: { username: user.username, password: user.password } }

      it 'returns access token' do
        response_json = JSON.parse(response.body)
        expect(response_json['access_token']).not_to be_nil
      end
    end

    context 'when invalid credentials' do
      before { post '/token',
        params: { username: 'barfoo', password: 'foobar' } }

      it 'returns error message' do
        response_json = JSON.parse(response.body)
        expect(response_json['errors']).not_to be_nil
      end
    end
  end
end
