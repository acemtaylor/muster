class EventLocation < ApplicationRecord
  belongs_to :event
  has_many :event_shifts, dependent: :nullify
end
