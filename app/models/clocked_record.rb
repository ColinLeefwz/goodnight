class ClockedRecord < ApplicationRecord
  MAX_SLOT = 86_400
  belongs_to :user

  enum status: %i[sleep wakeup]

  validates :clocked_in, presence: true
  validates :slot_seconds, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: MAX_SLOT }, if: :wakeup?
  validate :status_not_changed

  default_scope { order(clocked_in: :desc) }

  before_validation :set_status_and_slot, on: :create

  private

  def status_not_changed
    if status_changed? && self.persisted?
      errors.add(:status, "Change of status not allowed!")
    end
  end

  def set_status_and_slot
    latest_record = self.class.first
    return unless latest_record.present?

    clocked_in_slot = (self.clocked_in - latest_record.clocked_in).to_i
    return if clocked_in_slot > MAX_SLOT

    self.status = case latest_record&.status
             when 'sleep'
               :wakeup
             when 'wakeup'
               :sleep
             else
               :sleep
             end
    self.slot_seconds = clocked_in_slot if self.status == 'wakeup'
  end
end
