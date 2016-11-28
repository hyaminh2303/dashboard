require 'csv'

namespace :setting_daily_imp do
  task all: [:banner_size, :country_cost, :density, :daily_est_imp]

  desc "Create banner size"
  task banner_size: :environment do
    %w(320x50 300x250 728x90 320x480).each do |size|
      BannerSize.create(name: size, size: size) if BannerSize.find_by(size: size).blank?
    end
  end

  desc "Create Country Cost"
  task country_cost: :environment do
    file_path = File.join(Rails.root, 'lib/tasks/csv/country_cost.csv')
    file_encoding = get_file_encode(file_path)

    CSV.foreach(file_path, headers: true, encoding: file_encoding) do |row|
      params = {}
      row.to_hash.each { |k, v| params.merge!(k.tr('- ', '_').downcase => v) }

      if CountryCost.find_by(country_code: params['country_code']).blank?
        CountryCost.create(params)
      end
    end
  end

  desc "Create density"
  task density: :environment do
    CountryCost.all.each do |country_cost|
      file_path = File.join(Rails.root, 'lib/tasks/csv/cities', "#{country_cost.country_code}.csv")

      next unless File.exist?(file_path)

      file_encoding = get_file_encode(file_path)

      CSV.foreach(file_path, headers: true, encoding: file_encoding) do |row|
        params = {}
        row.to_hash.each { |k, v| params.merge!(k.tr('- ', '_').downcase => v) }

        if Density.find_by(country_code: country_cost.country_code, city_name: params['city_name']).blank?
          Density.create(params.merge(country_code: country_cost.country_code))
        end
      end
    end
  end

  desc "Create daily est impression"
  task daily_est_imp: :environment do
    file_path = File.join(Rails.root, 'lib/tasks/csv/daily_est_imp.csv')

    return unless File.exist?(file_path)

    file_encoding = get_file_encode(file_path)

    CSV.foreach(file_path, headers: true, encoding: file_encoding) do |row|
      params = {}
      row.to_hash.each { |k, v| params.merge!(k.tr('- ', '_').downcase => v) }
      banner_size = BannerSize.find_by(size: params['banner_size'])

      next if banner_size.blank?

      if DailyEstImp.find_by(country_code: params['country_code'], banner_size_id: banner_size.id).blank?
        DailyEstImp.create(params.merge(banner_size_id: banner_size.id))
      end
    end
  end

  def get_file_encode(path)
    CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]
  end
end
