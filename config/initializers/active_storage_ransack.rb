# Reopening the ActiveStorage::Attachment model to add ransackable_attributes
Rails.application.config.to_prepare do
  ActiveStorage::Attachment.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      [ "blob_id", "created_at", "id", "name", "record_id", "record_type" ]
    end
  end
end
