namespace :online_dashboard do
  task update_last_stats_at: :environment do
    Campaign.all.each do |campaign|
      campaign.update_last_stats_at
    end
  end
end