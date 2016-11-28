class OrderSetting < ActiveRecord::Base
  validates :key, :presence => true, :uniqueness => true

  scope :get_settings, ->{ where(setting_type: 1) }

  class << self
    def [](key)
      settings[key]
    end

    def settings
      @settings = {}
      settings = OrderSetting.all
      settings.each {|s| @settings[s.key.to_sym] = s.value}
      @settings
    end

    def method_missing(name, *args)
      OrderSetting[name]
    end
  end
end
