require 'rails_helper'

RSpec.describe 'Api::V1::Races', type: :request do
  describe 'GET /api/v1/races' do
    it 'returns only open races (not draft)' do
      open_race = create(:race, status: 'open', title: 'Open Race')
      draft_race = create(:race, :draft, title: 'Draft Race')
      closed_race = create(:race, :closed, title: 'Closed Race')

      get '/api/v1/races'

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      race_ids = json['data'].map { |r| r['id'].to_i }
      expect(race_ids).to include(open_race.id)
      expect(race_ids).not_to include(draft_race.id)
      expect(race_ids).not_to include(closed_race.id)
    end

    it 'returns races ordered by start_at ascending' do
      later = create(:race, status: 'open', start_at: 3.months.from_now)
      sooner = create(:race, status: 'open', start_at: 1.month.from_now)

      get '/api/v1/races'

      json = JSON.parse(response.body)
      ids = json['data'].map { |r| r['id'].to_i }
      expect(ids).to eq([sooner.id, later.id])
    end

    it 'uses JSONAPI::Serializer format' do
      create(:race, status: 'open')

      get '/api/v1/races'

      json = JSON.parse(response.body)
      expect(json).to have_key('data')
      expect(json['data'].first).to have_key('id')
      expect(json['data'].first).to have_key('type')
      expect(json['data'].first).to have_key('attributes')
    end
  end

  describe 'GET /api/v1/races/:id' do
    it 'returns a race with editions' do
      race = create(:race, :with_editions, status: 'open')

      get "/api/v1/races/#{race.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['data']['id'].to_i).to eq(race.id)
      expect(json['data']['attributes']['title']).to eq(race.title)

      # Included race editions
      expect(json['included']).to be_present
      edition_types = json['included'].map { |i| i['type'] }
      expect(edition_types).to include('race_edition')
    end

    it 'returns 404 for non-existent race' do
      get '/api/v1/races/999999'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Race not found')
    end

    it 'includes serialized attributes (title, location, status, start_at)' do
      race = create(:race, status: 'open', title: 'Seoul Marathon', location: 'Seoul')

      get "/api/v1/races/#{race.id}"

      json = JSON.parse(response.body)
      attrs = json['data']['attributes']
      expect(attrs['title']).to eq('Seoul Marathon')
      expect(attrs['location']).to eq('Seoul')
      expect(attrs['status']).to eq('open')
      expect(attrs).to have_key('start_at')
    end
  end
end
