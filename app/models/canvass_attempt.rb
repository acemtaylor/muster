class CanvassAttempt < ApplicationRecord
  belongs_to :canvass
  belongs_to :turf, optional: true
  belongs_to :person, optional: true
  belongs_to :canvasser, class_name: "TeamMember", optional: true

  KNOCK_RESULTS = %w[not_home canvassed refused bad_address].freeze

  validates :knock_result, inclusion: { in: KNOCK_RESULTS }, allow_nil: true
end
