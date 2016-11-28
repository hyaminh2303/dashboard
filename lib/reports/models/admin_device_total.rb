class Reports::Models::AdminDeviceTotal < Reports::Models::AdminDevice
  include Reports::Helpers::CampaignReportHelper

  def initialize(details)
    @views = get_total_views(details)
    @clicks = get_total_clicks(details)
    @number_of_device_ids = get_total_number_of_device_ids(details)
    @frequency_cap = get_total_frequency_cap(details)
    @ctr = get_ctr_by_total(details)
  end
end
