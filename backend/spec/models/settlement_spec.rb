require 'rails_helper'

RSpec.describe Settlement, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:total_revenue) }
    it { is_expected.to validate_presence_of(:platform_commission) }
    it { is_expected.to validate_presence_of(:organizer_payout) }
    it { is_expected.to validate_presence_of(:registration_count) }
    it { is_expected.to validate_numericality_of(:total_revenue).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:platform_commission).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:organizer_payout).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:registration_count).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organizer_profile) }
    it { is_expected.to belong_to(:race) }
  end

  describe 'enum :status' do
    it 'defines pending, confirmed, approved, paid, rejected' do
      expect(described_class.statuses).to eq(
        'pending' => 'pending',
        'confirmed' => 'confirmed',
        'approved' => 'approved',
        'paid' => 'paid',
        'rejected' => 'rejected'
      )
    end
  end

  describe '#calculate!' do
    it 'calculates commission as 5% + 500 won per registration' do
      organizer = create(:organizer_profile)
      race = create(:race, :with_editions, organizer: organizer)
      edition = race.race_editions.first

      # 유료 참가자 3명 (각 30,000원)
      3.times { create(:registration, :paid, race_edition: edition, payment_amount: 30000) }

      settlement = build(:settlement,
        organizer_profile: organizer,
        race: race,
        total_revenue: 0,
        registration_count: 0,
        platform_commission: 0,
        organizer_payout: 0
      )

      settlement.calculate!
      settlement.reload

      # total_revenue = 90,000
      expect(settlement.total_revenue).to eq(90_000)
      expect(settlement.registration_count).to eq(3)

      # platform_commission = (90,000 * 0.05) + (500 * 3) = 4,500 + 1,500 = 6,000
      expect(settlement.platform_commission).to eq(6_000)

      # organizer_payout = 90,000 - 6,000 = 84,000
      expect(settlement.organizer_payout).to eq(84_000)
    end

    it 'handles zero registrations' do
      organizer = create(:organizer_profile)
      race = create(:race, :with_editions, organizer: organizer)

      settlement = build(:settlement,
        organizer_profile: organizer,
        race: race,
        total_revenue: 0,
        registration_count: 0,
        platform_commission: 0,
        organizer_payout: 0
      )

      settlement.calculate!

      expect(settlement.total_revenue).to eq(0)
      expect(settlement.registration_count).to eq(0)
      expect(settlement.platform_commission).to eq(0)
      expect(settlement.organizer_payout).to eq(0)
    end
  end

  describe 'status flow and guard methods' do
    describe '#can_request?' do
      it 'returns true when pending with revenue > 0' do
        settlement = build(:settlement, status: 'pending', total_revenue: 100_000)
        expect(settlement.can_request?).to be true
      end

      it 'returns false when pending with zero revenue' do
        settlement = build(:settlement, status: 'pending', total_revenue: 0)
        expect(settlement.can_request?).to be false
      end

      it 'returns false when not pending' do
        settlement = build(:settlement, :confirmed, total_revenue: 100_000)
        expect(settlement.can_request?).to be false
      end
    end

    describe '#can_approve?' do
      it 'returns true when confirmed' do
        settlement = build(:settlement, :confirmed)
        expect(settlement.can_approve?).to be true
      end

      it 'returns false when pending' do
        settlement = build(:settlement, status: 'pending')
        expect(settlement.can_approve?).to be false
      end

      it 'returns false when approved' do
        settlement = build(:settlement, :approved)
        expect(settlement.can_approve?).to be false
      end
    end

    describe '#can_mark_paid?' do
      it 'returns true when approved' do
        settlement = build(:settlement, :approved)
        expect(settlement.can_mark_paid?).to be true
      end

      it 'returns false when confirmed' do
        settlement = build(:settlement, :confirmed)
        expect(settlement.can_mark_paid?).to be false
      end

      it 'returns false when paid' do
        settlement = build(:settlement, :paid)
        expect(settlement.can_mark_paid?).to be false
      end
    end

    describe 'full status flow: pending -> confirmed -> approved -> paid' do
      it 'transitions correctly through all states' do
        settlement = create(:settlement, status: 'pending')

        expect(settlement.can_request?).to be true
        settlement.update!(status: 'confirmed')

        expect(settlement.can_approve?).to be true
        settlement.update!(status: 'approved')

        expect(settlement.can_mark_paid?).to be true
        settlement.update!(status: 'paid')

        expect(settlement.can_request?).to be false
        expect(settlement.can_approve?).to be false
        expect(settlement.can_mark_paid?).to be false
      end
    end
  end
end
