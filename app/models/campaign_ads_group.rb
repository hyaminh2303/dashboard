class CampaignAdsGroup < ActiveRecord::Base
  belongs_to :campaign

  has_many :daily_trackings, foreign_key: 'group_id', dependent: :destroy

  scope :by_campaign, ->(id) { where(campaign_id: id)}

  validates :name,          length: { maximum: 255}, presence: true
  validates :keyword,       length: { maximum: 255}, presence: true
  validates :description,   length: { maximum: 255}

  validates_uniqueness_of :name, scope: [ :campaign_id]

  validates :target, presence: true, numericality: { greater_than: 0 }, if: :target_per_ad_group?
  validates :start_date, date: { after_or_equal_to: Proc.new { |c| c.campaign.active_at.to_date },
                                 before_or_equal_to: Proc.new { |c| c.campaign.expire_at.to_date } } , if: :target_per_ad_group?

  validates :end_date, date: { after: :start_date,
                               before_or_equal_to: Proc.new { |c| c.campaign.expire_at.to_date } } , if: :target_per_ad_group?

  private
  def target_per_ad_group?
    campaign.target_per_ad_group
  end
end
