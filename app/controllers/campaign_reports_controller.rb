class CampaignReportsController < ApplicationController

  def export
    campaign_id = params[:id]
    if can? :manage, Campaign
      os = Reports::CampaignBy::AdminOsReport.new campaign_id: campaign_id
      app = Reports::CampaignBy::AdminAppReport.new campaign_id: campaign_id
      daily = Reports::CampaignBy::AdminDailyReport.new campaign_id: campaign_id
      group = Reports::CampaignBy::AdminGroupReport.new campaign_id: campaign_id, order: { '0' => { column: 0}}
      device = Reports::CampaignBy::AdminDeviceReport.new campaign_id: campaign_id
      location = Reports::CampaignBy::AdminLocationReport.new campaign_id: campaign_id
      creative = Reports::CampaignBy::AdminCreativeReport.new campaign_id: campaign_id
    else
      os = Reports::CampaignBy::AgencyOsReport.new campaign_id: campaign_id
      app = Reports::CampaignBy::AdminAppReport.new campaign_id: campaign_id
      daily = Reports::CampaignBy::AgencyDailyReport.new campaign_id: campaign_id
      group = Reports::CampaignBy::AgencyGroupReport.new campaign_id: campaign_id, order: { '0' => { column: 0}}
      device = Reports::CampaignBy::AgencyDeviceReport.new campaign_id: campaign_id
      location = Reports::CampaignBy::AgencyLocationReport.new campaign_id: campaign_id
      creative = Reports::CampaignBy::AgencyCreativeReport.new campaign_id: campaign_id
    end

    # Response to excel
    render xlsx: 'campaign_report', filename: daily.get_filename, locals: {
                                      daily_report: daily,
                                      location_report: location,
                                      os_report: os,
                                      group_report: group,
                                      creative_report: creative,
                                      device_report: device,
                                      app_report: app
                                    }
  end

  def export_as_agency
    campaign_id = params[:id]
    campaign = Campaign.find(params[:id])

    os = Reports::CampaignBy::AgencyOsReport.new campaign_id: campaign_id
    app = Reports::CampaignBy::AdminAppReport.new campaign_id: campaign_id
    daily = Reports::CampaignBy::AgencyDailyReport.new campaign_id: campaign_id
    group = Reports::CampaignBy::AgencyGroupReport.new campaign_id: campaign_id, order: { '0' => { column: 0}}
    device = Reports::CampaignBy::AgencyDeviceReport.new campaign_id: campaign_id
    location = Reports::CampaignBy::AgencyLocationReport.new campaign_id: campaign_id
    creative = Reports::CampaignBy::AgencyCreativeReport.new campaign_id: campaign_id
    # Response to excel

    if campaign.apply_price_creative
      render xlsx: 'campaign_report_base_creatives/campaign_report',
        template: 'campaign_report_base_creatives/campaign_report',
        filename: daily.get_filename, locals: {
                                        daily_report: daily,
                                        location_report: location,
                                        group_report: group,
                                        creative_report: creative,
                                        os_report: os,
                                        device_report: device,
                                        app_report: app
                                      }
    else
      render xlsx: 'campaign_report', filename: daily.get_filename, locals: {
                                        daily_report: daily,
                                        location_report: location,
                                        group_report: group,
                                        creative_report: creative,
                                        os_report: os,
                                        device_report: device,
                                        app_report: app
                                      }
    end
  end
end
