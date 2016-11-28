class CountryCost < ActiveRecord::Base
  validates :country_code, :cpc, :cpm, :population, presence: true
end
