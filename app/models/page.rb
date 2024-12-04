class Page < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "title", "content", "created_at", "updated_at" ]
  end
end
