class MembershipTier < ApplicationRecord
  belongs_to :organization
  has_many :memberships, dependent: :restrict_with_error

  BILLING_PERIODS = %w[monthly annual one_time lifetime].freeze

  validates :name, presence: true
  validates :billing_period, inclusion: { in: BILLING_PERIODS }
  validates :price_cents, presence: true, unless: :income_based
end
