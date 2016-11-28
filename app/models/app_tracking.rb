class AppTracking < ActiveRecord::Base
  belongs_to :campaign
  validates :date, presence: true
  validate :unique_log

  def unique_log
    if self.new_record?
      unless AppTracking.where(:campaign_id => campaign_id, :date => date, :name => name).count == 0
        errors.add(:app_tracking, I18n.t('models.app_tracking.validate.already_add'))
      end
    end
  end
end
