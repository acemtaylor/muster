class CustomPropertyDefinition < ApplicationRecord
  belongs_to :organization
  has_many :custom_property_values, foreign_key: :definition_id, dependent: :destroy

  DATA_TYPES = %w[text select multiselect date boolean number].freeze

  validates :key, presence: true, uniqueness: { scope: :organization_id }
  validates :label, presence: true
  validates :data_type, inclusion: { in: DATA_TYPES }
end
