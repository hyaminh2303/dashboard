namespace :group do
  desc "Copy name to keyword"
  task keyword: :environment do
    CampaignAdsGroup.all.each do |group|
      if group.keyword.nil?
        group.update keyword: group.name, description: "#{group.description} (updated keyword)"
      end
    end
  end
end
