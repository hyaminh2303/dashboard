class Reports::CampaignBy::AdminPacingReport
  include Reports::Campaigns::PacingReport

  def initialize(options)
    init_report(options)

    @data = @campaign_details.map do |detail|
      instance = Reports::Models::AdminPacing.new detail, options
      instance
    end unless options[:skip_details]

    @total = Reports::Models::AdminPacingTotal.new @campaign_details, @options
  end

  def template_name
    'admin_by_pacing'
  end
end
