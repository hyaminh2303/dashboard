class SubTotalSetting < ActiveRecord::Base
  enum sub_total_setting_type: [:fixed, :percent]
  has_many :sub_totals, dependent: :destroy

  validates :name, :value, :sub_total_setting_type, presence: true
end
