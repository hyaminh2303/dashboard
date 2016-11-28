require 'csv'

class DailyEstImpService
  def initialize
    @file_path = File.join(Rails.root, 'config/daily_est_imps.csv')
    @banner_sizes = BannerSize.all
  end

  attr_reader :file_path, :banner_sizes

  def import_csv_to_sql
    database = Rails.application.secrets.database
    username = Rails.application.secrets.user_sql
    password = Rails.application.secrets.password_sql
    `mysqlimport  --ignore-lines=1 --fields-terminated-by=, --columns='@dummy,impression,@dummy,@dummy,@dummy,country_code,@dummy,banner_size' --local -u#{username} -p#{password} #{database} #{file_path}`
  end

  def fetch_data
    # CSV.foreach(file_path, headers: true, encoding: @file_encoding) do |row|


    CSV.foreach(file_path, headers: true) do |row|
      daily_est_imp_params = {}
      row.to_hash.each { |k, v| daily_est_imp_params.merge!(convert_snake_case(k) => v) }

      country_code = daily_est_imp_params['country']
      banner_size = daily_est_imp_params['ad_size']

      daily_est_imp = DailyEstImp.find_by(country_code: country_code,
                                          banner_size: banner_size)

      daily_est_imp_params['country']
    end
  end

  def clean_data
    DailyEstImp.where(is_manual: false).update_all(impression: 0)
  end

  def get_file_encode(path)
    CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]
  end

  def convert_snake_case(str)
    str.tr('- ', '_').downcase
  end
end