class Reports::CampaignBy::AdminDeviceReport
  include Reports::Campaigns::DeviceReport

  def initialize(options)
    init_report(options)

    @data = @campaign_details.map do |detail|
      Reports::Models::AdminDevice.new detail
    end unless options[:skip_details]

    @total = Reports::Models::AdminDeviceTotal.new @campaign_details
  end

  def template_name
    'admin_by_device'
  end
end
