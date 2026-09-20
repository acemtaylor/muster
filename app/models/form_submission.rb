class FormSubmission < ApplicationRecord
  belongs_to :page
  belongs_to :person, optional: true

  validates :answers, presence: true
end
