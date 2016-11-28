class Place < ActiveRecord::Base
  belongs_to :client_booking_campaign
  has_many :client_booking_locations, dependent: :destroy

  accepts_nested_attributes_for :client_booking_locations, allow_destroy: true

end
