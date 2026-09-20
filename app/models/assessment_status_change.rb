class AssessmentStatusChange < ApplicationRecord
  belongs_to :person
  belongs_to :changed_by, class_name: "TeamMember", optional: true
end
