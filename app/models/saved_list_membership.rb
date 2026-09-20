class SavedListMembership < ApplicationRecord
  self.primary_key = nil
  belongs_to :saved_list
end
