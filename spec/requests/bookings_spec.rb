require 'rails_helper'

RSpec.describe 'Bookings API' do
  let!(:bookings) { create_list(:booking, 10) }
  let(:booking_id) { bookings.first.id }
  let(:rental) { create(:rental) }
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JwtHandler.encode(user_id: user.id) } }

  describe 'GET /bookings' do
    before { get '/bookings', headers: header }

    it 'returns the list of bookings' do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].length).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  describe 'GET /bookings/:id' do
    context 'when booking exists' do
      before { get "/bookings/#{booking_id}", headers: header }

      it 'returns requested booking' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id'].to_i).to eq(booking_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when booking does not exist' do
      before { get "/bookings/#{booking_id + 100}", headers: header }

      it 'returns error object' do
        response_json = JSON.parse(response.body)
        expect(response_json['errors']).not_to be_empty
      end

      it 'returns status :not_found code' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /bookings' do
    let(:valid_attrs) do
      {
        data: {
          attributes: attributes_for(:booking),
          relationships: {
            rental: {
              data: attributes_for(:rental).merge(id: rental.id)
            }
          }
        }
      }
    end
    let(:invalid_attrs) do
      {
        data: {
          attributes: {
            start_at: "2017-11-12 11:48:52",
            end_at: "2017-11-12 11:48:52",
            client_email: "",
            price: "9.99"
          },
          relationships: {
            rental: {
              data: attributes_for(:rental).merge(id: rental.id)
            }
          }
        }
      }
    end

    context 'when valid attributes' do
      before { post '/bookings', params: valid_attrs, headers: header }

      it 'returns a new booking' do
        response_json = JSON.parse(response.body)
        expect(response_json['data']['attributes']['start-at']).not_to be_nil
      end

      it 'returns response with status created' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when not valid attributes' do
      before { post '/bookings', params: invalid_attrs, headers: header }

      it 'returns error object' do
        response_json = JSON.parse(response.body)
        expect(response_json['errors']).not_to be_empty
      end

      it 'returns response with status unprocessable_entity' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /bookings/:id' do
      let(:update_attrs) do
        {
          data: {
            attributes: {
              start_at: "2018-11-12 11:48:52"
            }
          }
        }
      end
      before { patch "/bookings/#{booking_id}", params: update_attrs, headers: header }

      it 'updates the booking' do
        updated_booking = Booking.find(booking_id)
        expect(updated_booking.start_at).
          to eq(update_attrs[:data][:attributes][:start_at])
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    describe 'DELETE /bookings/:id' do
      before { delete "/bookings/#{booking_id}", headers: header }

      it 'deletes the booking' do
        expected_nil = Booking.find_by_id(booking_id)
        expect(expected_nil).to be_nil
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
