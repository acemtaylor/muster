class SavedList < ApplicationRecord
  belongs_to :organization
  belongs_to :folder, class_name: "ListFolder", optional: true
  belongs_to :created_by, class_name: "TeamMember", optional: true

  validates :name, presence: true
  validates :subject_type, inclusion: { in: %w[person event] }
  validates :filter_json, presence: true

  def run
    ::Filters::Compiler.new(subject_type: subject_type).compile(filter_json)
  end
end
