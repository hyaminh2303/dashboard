class Publisher < ActiveRecord::Base

  #Enum
  STATUSES = [
      STATUS_PUBLISHED = 'published',
      STATUS_PEDING = 'pending',
      STATUS_EXPIRED = 'expired'
  ]

  belongs_to :user


  scope :published, -> { where(status: STATUS_PUBLISHED)}

end
