class Density < ActiveRecord::Base
  validate :country_code, :city_name, presence: true
end
