class TeamMember < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization

  ROLES = %w[admin staff volunteer].freeze
  validates :role, inclusion: { in: ROLES }
end
