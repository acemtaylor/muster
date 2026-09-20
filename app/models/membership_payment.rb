class MembershipPayment < ApplicationRecord
  belongs_to :membership

  validates :amount_cents, numericality: { greater_than: 0 }
end
