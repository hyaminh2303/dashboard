class BannerSize < ActiveRecord::Base
  validates :name, :size, presence: true
end
