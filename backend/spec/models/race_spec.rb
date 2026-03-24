require 'rails_helper'

RSpec.describe Race, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:status) }

    it 'validates title length (min 3, max 100)' do
      race = build(:race, title: 'ab')
      expect(race).not_to be_valid
      expect(race.errors[:title]).to be_present
    end

    it 'validates status inclusion' do
      expect { build(:race, status: 'invalid') }.to raise_error(ArgumentError)
    end

    it 'validates registration_end_at is after registration_start_at' do
      race = build(:race,
        registration_start_at: 1.week.from_now,
        registration_end_at: 1.day.ago
      )
      expect(race).not_to be_valid
      expect(race.errors[:registration_end_at]).to be_present
    end

    it 'validates refund_deadline is before start_at' do
      race = build(:race,
        start_at: 1.month.from_now,
        refund_deadline: 2.months.from_now
      )
      expect(race).not_to be_valid
      expect(race.errors[:refund_deadline]).to be_present
    end
  end

  describe 'enum :status' do
    it 'defines draft, open, closed, finished' do
      expect(described_class.statuses).to eq(
        'draft' => 'draft',
        'open' => 'open',
        'closed' => 'closed',
        'finished' => 'finished'
      )
    end

    it 'defaults to draft' do
      race = described_class.new
      expect(race.status).to eq('draft')
    end
  end

  describe '#registration_open?' do
    it 'returns true when status is open and within registration period' do
      race = build(:race,
        status: 'open',
        registration_start_at: 1.day.ago,
        registration_end_at: 1.day.from_now
      )
      expect(race.registration_open?).to be true
    end

    it 'returns false when status is draft' do
      race = build(:race, :draft,
        registration_start_at: 1.day.ago,
        registration_end_at: 1.day.from_now
      )
      expect(race.registration_open?).to be false
    end

    it 'returns false when registration period has ended' do
      race = build(:race,
        status: 'open',
        registration_start_at: 2.weeks.ago,
        registration_end_at: 1.week.ago
      )
      expect(race.registration_open?).to be false
    end

    it 'returns false when registration dates are nil' do
      race = build(:race,
        status: 'open',
        registration_start_at: nil,
        registration_end_at: nil
      )
      expect(race.registration_open?).to be false
    end
  end

  describe 'scopes' do
    describe '.upcoming' do
      it 'returns races with start_at in the future' do
        future_race = create(:race, start_at: 1.month.from_now)
        past_race = create(:race, start_at: 1.month.ago)

        expect(described_class.upcoming).to include(future_race)
        expect(described_class.upcoming).not_to include(past_race)
      end

      it 'orders by start_at ascending' do
        later = create(:race, start_at: 3.months.from_now)
        sooner = create(:race, start_at: 1.month.from_now)

        expect(described_class.upcoming.first).to eq(sooner)
      end
    end

    describe '.open_for_registration' do
      it 'returns races within registration period' do
        open_race = create(:race,
          registration_start_at: 1.day.ago,
          registration_end_at: 1.week.from_now
        )
        closed_race = create(:race,
          registration_start_at: 2.months.ago,
          registration_end_at: 1.month.ago
        )

        expect(described_class.open_for_registration).to include(open_race)
        expect(described_class.open_for_registration).not_to include(closed_race)
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:race_editions).dependent(:destroy) }
    it { is_expected.to have_many(:registrations).through(:race_editions) }
    it { is_expected.to have_many(:products).dependent(:destroy) }
    it { is_expected.to belong_to(:organizer).class_name('OrganizerProfile').optional }
  end
end
