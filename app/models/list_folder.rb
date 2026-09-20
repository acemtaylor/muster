class ListFolder < ApplicationRecord
  belongs_to :organization
  has_many :saved_lists, foreign_key: :folder_id, dependent: :nullify
end
