class SettingUpdater
  extend CarrierWave::Mount

  attr_accessor :logo
  attr_accessor :slogan
  attr_accessor :address
  attr_accessor :terms_and_conditions
  attr_accessor :authorization
  attr_accessor :amendment

  mount_uploader :logo, LogoUploader

  def initialize(params)
    params.each_pair do |key, value|
      send("#{key}=", value)
    end
  end

  def update(has_logo = true)
    keys = [:logo, :slogan, :address, :terms_and_conditions, :authorization, :amendment]
    keys.delete(:logo) unless has_logo
    keys.each do |key|
      update_setting(key, transform_value(key, self.send(key)))
    end
  end

  private

  def update_setting(key, value)
    setting = OrderSetting.find_by(key: key)
    if setting
      setting.update(value: value)
    else
      OrderSetting.create!(key: key, value: value)
    end
  end

  def transform_value(key, value)
    return value unless key.to_sym == :logo
    store_logo!
    value.url
  end
end