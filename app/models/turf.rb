class Turf < ApplicationRecord
  belongs_to :organization
  has_many :canvass_attempts, dependent: :nullify

  validates :name, presence: true
  validates :boundary, presence: true
end
