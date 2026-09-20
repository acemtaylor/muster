class Page < ApplicationRecord
  belongs_to :organization
  has_many :form_submissions, dependent: :destroy

  validates :slug, presence: true, uniqueness: { scope: :organization_id }

  def blocks
    content_json.fetch("blocks", [])
  end

  def form_fields
    blocks.select { |b| b["type"] == "form" }.flat_map { |b| b["fields"] || [] }
  end
end
