class Automation < ApplicationRecord
  belongs_to :organization
  has_many :automation_steps, -> { order(:position) }, dependent: :destroy

  TRIGGER_TYPES = %w[person_created assessment_changed form_submitted event_rsvp].freeze

  validates :name, presence: true
  validates :trigger_type, inclusion: { in: TRIGGER_TYPES }
end

