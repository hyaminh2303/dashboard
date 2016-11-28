prawn_document({renderer: ExecutiveReport, live_campaigns: @live_campaigns, incoming_campaigns: @incoming_campaigns}) do |pdf|

  pdf.header_section 'EXECUTIVE REPORT - CAMPAIGNS OVERVIEW'

  pdf.campaigns_overview

  pdf.campaign_health_info

  pdf.campaigns_analytic

  pdf.header_section 'INCOMING CAMPAIGNS'

  pdf.incoming_campaigns

end