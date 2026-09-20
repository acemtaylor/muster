class Person < ApplicationRecord
  belongs_to :organization
  has_many :custom_property_values, dependent: :destroy

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  def full_name
    [ first_name, last_name ].compact_blank.join(" ")
  end
end
