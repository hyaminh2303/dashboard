namespace :location_tracking do
  desc 'Copy location name to tracking name'
  task :copy_name => :environment do
    LocationTracking.all.each do |t|
      t.update name: t.location.name
      puts "Copy #{t.location.name} to location tracking id #{t.id}"
    end
  end

  desc 'Copy date to created_at & updated_at'
  task :copy_date => :environment do
    LocationTracking.where(created_at: nil, updated_at: nil).each do |t|
      t.update created_at: t.date.to_time, updated_at: t.date.to_time
    end
  end

  desc 'add value for ctr column'
  task :calculate_ctr => :environment do
    LocationTracking.all.each do |t|
      ctr = 0
      if t.views.blank?
        ctr = 0
      else
        t.views == 0 ? ctr = 0 : ctr = (100.0 * t.clicks / t.views).round(4)
      end
      t.update ctr: ctr
    end
  end
end
