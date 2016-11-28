class Reports::Models::AdminDevice
  include Reports::Models::TrackingRecord
  include Reports::Helpers::CampaignReportHelper

  attr_reader :group_ads_name

  def initialize(detail)
    init_detail(detail)
    @group_ads_name = detail.name
  end

  def hash
    _hash = hash_detail

    unless @group_ads_name.nil?
      _hash[:group_ads_name] = @group_ads_name
    else
      _hash[:group_ads_name] = ''
    end
    _hash
  end
end
