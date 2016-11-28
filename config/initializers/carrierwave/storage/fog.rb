CarrierWave.configure do |config|
  unless Figaro.env.video_ads_aws_access_key_id.nil? or
      Figaro.env.video_ads_aws_secret_access_key.nil? or
      Figaro.env.aws_region.nil? or
      Figaro.env.video_ads_bucket.nil?

    config.fog_credentials = {
        :provider               => 'AWS',                        # required
        :aws_access_key_id      =>  Figaro.env.video_ads_aws_access_key_id,                        # required
        :aws_secret_access_key  =>  Figaro.env.video_ads_aws_secret_access_key,                        # required
        :region                 =>  Figaro.env.aws_region,                  # optional, defaults to 'us-east-1'
        :host                   =>  Figaro.env.aws_host,             # optional, defaults to nil
    }
    config.fog_directory  = Figaro.env.video_ads_bucket                    # required
    config.fog_public     = true                                        # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
  end
end