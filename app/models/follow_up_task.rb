class FollowUpTask < ApplicationRecord
  belongs_to :person
  belongs_to :assigned_to, class_name: "TeamMember", optional: true

  def complete!
    update!(completed_at: Time.current)
  end

  def completed?
    completed_at.present?
  end
end
