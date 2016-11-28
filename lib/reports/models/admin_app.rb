class Reports::Models::AdminApp
  include Reports::Models::TrackingRecord
  include Reports::Helpers::CampaignReportHelper

  attr_reader :app_name

  def initialize(detail, campaign)
    init_detail(detail, campaign)
    @app_name = detail.name
  end

  def hash
    _hash = hash_detail
    _hash[:views] = '' if _hash[:views] == -1
    _hash[:clicks] = '' if _hash[:clicks] == -1
    _hash[:app_name] = @app_name unless @app_name.nil?
    _hash
  end
end
