class AutomationStep < ApplicationRecord
  belongs_to :automation

  STEP_TYPES = %w[delay send_email send_sms add_tag update_property decision].freeze

  validates :step_type, inclusion: { in: STEP_TYPES }
  validates :position, presence: true
end
