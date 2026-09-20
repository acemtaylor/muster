class ShiftSignup < ApplicationRecord
  belongs_to :event_shift
  belongs_to :person

  validates :person_id, uniqueness: { scope: :event_shift_id }
  validates :status, inclusion: { in: %w[draft confirmed cancelled no_show completed] }
end
