class ClientBookingCampaign < ActiveRecord::Base
  serialize :banner_size, Array
  serialize :app_category, Array
  has_many :places, dependent: :destroy
  has_many :banners, dependent: :destroy

  accepts_nested_attributes_for :places, allow_destroy: true
  accepts_nested_attributes_for :banners, allow_destroy: true

  enum status: [:waiting_for_approval, :approved, :closed]

  scope :with_status, -> (status) { where(status: statuses[status.to_sym]) }

  statuses.each do |st|
    define_method "#{st.to_s}?" do
      st == status
    end
  end

  class << self
    def filter_campaigns(params)
      campaigns = all
      campaigns = campaigns.where('campaign_name LIKE ?', "%#{params[:campaign_name]}%") if params[:campaign_name].present?
      campaigns = campaigns.where('advertiser_name LIKE ?', "%#{params[:advertiser_name]}%") if params[:advertiser_name].present?
      campaigns = campaigns.with_status(params[:status]) if params[:status].present?
      campaigns = campaigns.order("#{params[:sort_by]} #{params[:sort_dir]}") if params[:sort_by].present?
      campaigns
    end
  end
end
