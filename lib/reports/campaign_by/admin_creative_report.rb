class Reports::CampaignBy::AdminCreativeReport
  include Reports::Campaigns::CreativeReport

  def initialize(options)
    init_report(options)

    @data = @campaign_details.map do |detail|
      Reports::Models::AdminCreative.new detail, @campaign
    end unless options[:skip_details]

    @total = Reports::Models::AdminCreativeTotal.new @campaign_details
  end

  def template_name
    'admin_by_creative'
  end
end
