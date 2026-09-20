class Canvass < ApplicationRecord
  belongs_to :organization
  has_many :canvass_attempts, dependent: :destroy

  validates :name, presence: true
end
