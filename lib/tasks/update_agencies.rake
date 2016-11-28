namespace :update_agencies do
  desc "update channel of all agencies to Direct"
  task update: :environment do
    Agency.update_all(channel: 'Direct', currency_id: 1)
    puts "==> Done"
  end
end

