class CustomPropertyValue < ApplicationRecord
  belongs_to :person
  belongs_to :definition, class_name: "CustomPropertyDefinition"

  validates :definition_id, uniqueness: { scope: :person_id }
end
