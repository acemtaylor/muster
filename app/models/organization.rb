class Organization < ApplicationRecord
  belongs_to :parent, class_name: "Organization", optional: true
  has_many :children, class_name: "Organization", foreign_key: :parent_id, dependent: :nullify

  after_create :set_path
  before_update :set_path, if: :parent_id_changed?

  private

  def set_path
    new_path = parent_id.present? ? "#{Organization.find(parent_id).path}.#{id}" : id.to_s
    update_column(:path, new_path)
    update_column(:depth, new_path.count('.'))
  end
end
