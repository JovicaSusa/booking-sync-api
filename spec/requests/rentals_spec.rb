require 'rails_helper'

RSpec.describe 'Rentals API' do
  let!(:rentals) { create_list(:rental, 10) }
  let(:rental_id) { rentals.first.id }
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JwtHandler.encode(user_id: user.id) } }

  describe 'GET /rentals' do
    before { get '/rentals', headers: header }

    it 'returns the list of rentals' do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].length).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  describe 'GET /rentals/:id' do
    context 'when rental exists' do
      before { get "/rentals/#{rental_id}", headers: header }

      it 'returns requested rental' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id'].to_i).to eq(rental_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when rental does not exist' do
      before { get "/rentals/#{rental_id + 100}", headers: header }

      it 'returns error object' do
        response_json = JSON.parse(response.body)
        expect(response_json['errors']).not_to be_empty
      end

      it 'returns status :not_found code' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /rentals' do
    let(:valid_attrs) do
      {
        data: {
          attributes: attributes_for(:rental)
        }
      }
    end
    let(:invalid_attrs) do
      {
        data: {
          attributes: {
            name: "Test Rental",
            daily_rate: ""
          }
        }
      }
    end

    context 'when valid attributes' do
      before { post '/rentals', params: valid_attrs, headers: header }

      it 'returns a new rental' do
        response_json = JSON.parse(response.body)
        expect(response_json['data']['attributes']['name']).not_to be_nil
      end

      it 'returns response with status created' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when not valid attributes' do
      before { post '/rentals', params: invalid_attrs, headers: header }

      it 'returns error object' do
        response_json = JSON.parse(response.body)
        expect(response_json['errors']).not_to be_empty
      end

      it 'returns response with status unprocessable_entity' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /rentals/:id' do
      let(:update_attrs) do
        {
          data: {
            attributes: {
              daily_rate: 15
            }
          }
        }
      end
      before { patch "/rentals/#{rental_id}", params: update_attrs, headers: header }

      it 'updates the rental' do
        updated_rental = Rental.find(rental_id)
        expect(updated_rental.daily_rate).
          to eq(update_attrs[:data][:attributes][:daily_rate])
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    describe 'DELETE /rentals/:id' do
      before { delete "/rentals/#{rental_id}", headers: header }

      it 'deletes the rental' do
        expected_nil = Rental.find_by_id(rental_id)
        expect(expected_nil).to be_nil
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
