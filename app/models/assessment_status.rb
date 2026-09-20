class AssessmentStatus < ApplicationRecord
  belongs_to :organization

  validates :key, presence: true, uniqueness: { scope: :organization_id }
  validates :label, presence: true
end
