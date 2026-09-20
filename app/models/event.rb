class Event < ApplicationRecord
  belongs_to :organization
  has_many :event_locations, dependent: :destroy
  has_many :event_shifts, dependent: :destroy
  has_many :event_rsvps, dependent: :destroy

  validates :title, presence: true
  validates :starts_at, presence: true

  before_save :recompute_multi_day

  private

  def recompute_multi_day
    shifts = event_shifts.reload
    return if shifts.empty?

    dates = shifts.flat_map { |s| [ s.starts_at.to_date, s.ends_at.to_date ] }
    self.is_multi_day = dates.uniq.size > 1
  end
end
