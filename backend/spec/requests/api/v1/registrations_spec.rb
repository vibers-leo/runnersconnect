require 'rails_helper'

RSpec.describe 'Api::V1::Registrations', type: :request do
  let(:user) { create(:user) }
  let(:race) { create(:race, status: 'open') }
  let(:edition) { create(:race_edition, race: race, price: 30000, capacity: 100) }

  describe 'POST /api/v1/registrations' do
    context 'when authenticated' do
      before { sign_in user }

      it 'creates a pending registration' do
        post '/api/v1/registrations', params: { race_edition_id: edition.id }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('Registration created successfully.')

        registration = Registration.last
        expect(registration.status).to eq('pending')
        expect(registration.user).to eq(user)
        expect(registration.race_edition).to eq(edition)
        expect(registration.payment_amount).to eq(30000)
        expect(registration.merchant_uid).to be_present
        expect(registration.qr_token).to be_present
      end

      it 'rejects duplicate registration for same edition' do
        create(:registration, user: user, race_edition: edition)

        post '/api/v1/registrations', params: { race_edition_id: edition.id }

        expect(response).to have_http_status(:conflict)
        json = JSON.parse(response.body)
        expect(json['error']).to include('already registered')
      end

      it 'rejects registration when edition is full' do
        edition.update!(capacity: 1, current_count: 1)

        post '/api/v1/registrations', params: { race_edition_id: edition.id }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to include('full')
      end
    end

    context 'when not authenticated' do
      it 'returns 401 unauthorized' do
        post '/api/v1/registrations', params: { race_edition_id: edition.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/registrations' do
    context 'when authenticated' do
      before { sign_in user }

      it "returns user's registrations" do
        my_reg = create(:registration, user: user, race_edition: edition)
        other_reg = create(:registration, race_edition: edition) # different user

        get '/api/v1/registrations'

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        reg_ids = json['data'].map { |r| r['id'].to_i }
        expect(reg_ids).to include(my_reg.id)
        expect(reg_ids).not_to include(other_reg.id)
      end

      it 'returns registrations ordered by created_at desc' do
        older = create(:registration, user: user, race_edition: edition, created_at: 2.days.ago)
        edition2 = create(:race_edition, race: race, name: '5K', distance: 5, price: 20000)
        newer = create(:registration, user: user, race_edition: edition2, created_at: 1.day.ago)

        get '/api/v1/registrations'

        json = JSON.parse(response.body)
        ids = json['data'].map { |r| r['id'].to_i }
        expect(ids).to eq([newer.id, older.id])
      end

      it 'uses JSONAPI::Serializer format' do
        create(:registration, user: user, race_edition: edition)

        get '/api/v1/registrations'

        json = JSON.parse(response.body)
        expect(json).to have_key('data')
        expect(json['data'].first['attributes']).to have_key('status')
        expect(json['data'].first['attributes']).to have_key('merchant_uid')
      end
    end

    context 'when not authenticated' do
      it 'returns 401 unauthorized' do
        get '/api/v1/registrations'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
