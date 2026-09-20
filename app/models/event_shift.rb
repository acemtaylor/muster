class EventShift < ApplicationRecord
  belongs_to :event
  belongs_to :event_location, optional: true
  has_many :shift_signups, dependent: :destroy

  validates :starts_at, presence: true
  validates :ends_at, presence: true

  after_save :recompute_event_multi_day
  after_destroy :recompute_event_multi_day

  def confirmed_signups_count
    shift_signups.where(status: "confirmed").count
  end

  def full?
    capacity.present? && confirmed_signups_count >= capacity
  end

  private

  def recompute_event_multi_day
    event.event_shifts.reload
    event.save
  end
end
