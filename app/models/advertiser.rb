class Advertiser < ActiveRecord::Base

  # Enum
  STATUSES = [
      STATUS_PENDING = 'pending',
      STATUS_PUBLISHED = 'published',
      STATUS_EXPIRED = 'expired'
  ]

  belongs_to :user

  scope :published, -> { where(status: STATUS_PUBLISHED)}

  after_initialize do
    if new_record?
      self.status = STATUS_PUBLISHED
    end
  end
end
