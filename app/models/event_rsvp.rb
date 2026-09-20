class EventRsvp < ApplicationRecord
  belongs_to :event
  belongs_to :person

  validates :person_id, uniqueness: { scope: :event_id }
  validates :status, inclusion: { in: %w[yes maybe no waitlisted] }
end
