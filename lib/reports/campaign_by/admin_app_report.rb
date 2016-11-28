class Reports::CampaignBy::AdminAppReport
  include Reports::Campaigns::AppReport

  attr_reader :no_data

  def initialize(options)
    init_report(options)

    @data = @campaign_details.map do |detail|
      Reports::Models::AdminApp.new detail, @campaign
    end unless options[:skip_details]

    num_of_fail = 0
    @data.each do |app|
      if app.views == -1 && app.clicks == -1
        num_of_fail = num_of_fail + 1
      end
    end
    @no_data = false
    @no_data = true if num_of_fail == @data.length
  end

  def template_name
    'admin_by_app'
  end

end
