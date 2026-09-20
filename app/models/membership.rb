class Membership < ApplicationRecord
  belongs_to :person
  belongs_to :membership_tier
  has_many :membership_payments, dependent: :destroy

  STATUSES = %w[pending active lapsed cancelled].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  def active_dues_payer?
    status == "active" && (expires_at.nil? || expires_at > Time.current)
  end

  def renew!(amount_cents: self.amount_cents, processor: nil, processor_ref: nil)
    period_length = case membership_tier.billing_period
                     when "monthly" then 1.month
                     when "annual"  then 1.year
                     else
                       raise "Cannot auto-calculate renewal period for #{membership_tier.billing_period} tier"
                     end

    transaction do
      membership_payments.create!(amount_cents: amount_cents, processor: processor, processor_ref: processor_ref)
      new_expiry = (expires_at || Time.current) + period_length
      update!(expires_at: new_expiry, status: "active")
    end
  end

  def cancel!
    update!(status: "cancelled", cancelled_at: Time.current)
  end

  def lapse!
    update!(status: "lapsed")
  end
end
