namespace :unit_price do
  desc "update channel of all agencies to Direct"
  task update_creative: :environment do
    Campaign.all.each do |campaign|
      campaign.creative_trackings.each do |creative|
        if creative.unit_price.blank?
          creative.update(unit_price: campaign.unit_price_in_usd.to_f/100)
        end
      end
    end
  end
end
