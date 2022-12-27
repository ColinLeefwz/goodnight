require 'rails_helper'

RSpec.describe ClockedRecord, type: :model do
  describe '#valid?' do
    let!(:user) { create(:user) }
    let!(:clocked_record) { create(:clocked_record, user: user) }

    context 'when user is blank' do
      it 'return false' do
        clocked_record.user = nil
        expect(clocked_record.valid?).to be false
      end
    end

    context 'when clocked_in is blank' do
      it 'return false' do
        clocked_record.clocked_in = nil
        expect(clocked_record.valid?).to be false
      end
    end

    context 'when status is changed' do
      it 'return false' do
        clocked_record.status = :wakeup
        expect(clocked_record.valid?).to be false
      end
    end

    context 'when status of second clocked record is wakeup' do
      let!(:second_clocked_record) { create(:clocked_record, clocked_in: 5.minutes.since, user: user) }

      context 'when slot_seconds is blank' do
        it 'returns false' do
          second_clocked_record.slot_seconds = nil
          expect(second_clocked_record.valid?).to be false
        end
      end

      context 'when slot_seconds is 0' do
        it 'returns false' do
          second_clocked_record.slot_seconds = 0
          expect(second_clocked_record.valid?).to be false
        end
      end

      context 'when slot_seconds excceed the limitation' do
        it 'returns false' do
          second_clocked_record.slot_seconds = described_class::MAX_SLOT + 1
          expect(second_clocked_record.valid?).to be false
        end
      end

      it 'is valid' do
        expect(second_clocked_record.reload.slot_seconds).to eq 300
        expect(second_clocked_record.valid?).to be true
      end
    end

    it 'is valid' do
      expect(clocked_record.valid?).to be true
      expect(clocked_record.slot_seconds).to be nil
    end
  end
end
