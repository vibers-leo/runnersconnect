require 'rails_helper'

RSpec.describe Registration, type: :model do
  describe 'validations' do
    subject { build(:registration) }

    it { is_expected.to validate_presence_of(:merchant_uid) }
    it { is_expected.to validate_uniqueness_of(:merchant_uid) }

    it 'validates user_id uniqueness scoped to race_edition_id' do
      existing = create(:registration)
      duplicate = build(:registration,
        user: existing.user,
        race_edition: existing.race_edition
      )
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include('이미 해당 대회에 신청하셨습니다.')
    end

    it { is_expected.to validate_numericality_of(:payment_amount).is_greater_than_or_equal_to(0) }
  end

  describe 'enum :status' do
    it 'defines pending, paid, cancelled, refunded' do
      expect(described_class.statuses).to eq(
        'pending' => 'pending',
        'paid' => 'paid',
        'cancelled' => 'cancelled',
        'refunded' => 'refunded'
      )
    end

    it 'defaults to pending' do
      registration = described_class.new
      expect(registration.status).to eq('pending')
    end
  end

  describe 'enum :shipping_status' do
    it 'defines preparing, shipped, delivered, picked_up' do
      expect(described_class.shipping_statuses).to eq(
        'preparing' => 'preparing',
        'shipped' => 'shipped',
        'delivered' => 'delivered',
        'picked_up' => 'picked_up'
      )
    end
  end

  describe 'callbacks' do
    describe '#generate_qr_token' do
      it 'generates qr_token on create' do
        registration = create(:registration)
        expect(registration.qr_token).to be_present
        expect(registration.qr_token.length).to eq(24) # hex(12) = 24 chars
      end
    end

    describe '#increment_edition_count' do
      it 'increments race_edition current_count on create' do
        edition = create(:race_edition, current_count: 0)
        create(:registration, race_edition: edition)
        expect(edition.reload.current_count).to eq(1)
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:race_edition) }
    it { is_expected.to belong_to(:crew).optional }
    it { is_expected.to have_one(:race).through(:race_edition) }
  end

  describe '#can_change_bib_number?' do
    it 'returns true for pending registration with future race' do
      race = create(:race, start_at: 1.month.from_now)
      edition = create(:race_edition, race: race)
      registration = create(:registration, race_edition: edition, status: 'pending')
      expect(registration.can_change_bib_number?).to be true
    end

    it 'returns false for cancelled registration' do
      race = create(:race, start_at: 1.month.from_now)
      edition = create(:race_edition, race: race)
      registration = create(:registration, race_edition: edition, status: 'cancelled')
      expect(registration.can_change_bib_number?).to be false
    end
  end

  describe 'scopes' do
    describe '.souvenir_received / .souvenir_pending' do
      it 'filters by souvenir_received_at presence' do
        received = create(:registration, souvenir_received_at: Time.current)
        pending_reg = create(:registration, souvenir_received_at: nil)

        expect(described_class.souvenir_received).to include(received)
        expect(described_class.souvenir_received).not_to include(pending_reg)
        expect(described_class.souvenir_pending).to include(pending_reg)
        expect(described_class.souvenir_pending).not_to include(received)
      end
    end
  end
end
