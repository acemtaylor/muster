class Donation < ApplicationRecord
  belongs_to :person, optional: true

  validates :amount_cents, numericality: { greater_than: 0 }
end
