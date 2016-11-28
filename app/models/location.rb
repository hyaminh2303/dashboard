class Location < ActiveRecord::Base
  validate :validate_longitude_latitude

  validates :latitude, numericality: { greater_than_or_equal_to: -90.9999999, less_than_or_equal_to: 90.9999999}
  validates :longitude, numericality: { greater_than_or_equal_to: -180.9999999, less_than_or_equal_to: 180.9999999}

  # Enum
  STATUSES = [
      STATUS_PENDING = 'pending',
      STATUS_PUBLISHED = 'published',
      STATUS_EXPIRED = 'expired'
  ]
  #------------------------------- begin associations ------------------------------#
  belongs_to :user
  
  has_and_belongs_to_many :location_lists

  # @author The Anh
  # @date 170415
  has_many :location_trackings

  #------------------------------- begin named scopes ------------------------------#
  scope :published, -> { where(status: STATUS_PUBLISHED)}

  #------------------------------- begin instances ---------------------------------#
  def validate_longitude_latitude
    Location.where(longitude: longitude, latitude: latitude).count > 0 ? false : true
  end

  # @author The Anh
  # @date 180415
  def self.search(keyword=nil, user=nil)
    locations = self
    # search by keyword
    if !keyword.nil? && keyword.strip.length > 0
      tokens = keyword.gsub('、', ',').split(',').collect {|c| "%#{c.downcase.strip}%"}
      arr_filter_columns = ['`locations`.`name`']
      locations = locations.where(((["CONCAT_WS(' ', " + arr_filter_columns.join(', ') + ') LIKE ?']*tokens.size).join(' OR ')),*(tokens).collect{ |token| [token] }.flatten)
    end
    # check permission
    locations.joins("LEFT JOIN (
        select 
          `location_trackings`.`location_id`,
          `location_trackings`.`clicks`,
          `location_trackings`.`views`,
          `location_trackings`.`date`,
          `location_trackings`.`campaign_id`,
          `campaigns`.`name` as `campaign_name`, 
          `campaigns`.`has_ads_group` as `campaigns_has_ads_group`
        from
            `location_trackings`
        INNER JOIN `campaigns` ON `campaigns`.`id` = `location_trackings`.`campaign_id`
        ) as location_trackings ON `location_trackings`.`location_id` = `locations`.`id`")
    .group("`location_trackings`.`location_id`, `location_trackings`.`campaign_id`")
    .select("`location_trackings`.`location_id` as location_id, 
            `locations`.`name` as name, 
            sum(`location_trackings`.`views`) as views_count, 
            sum(`location_trackings`.`clicks`) as clicks_count, 
            100 * sum(`location_trackings`.`clicks`) / sum(`location_trackings`.`views`) as CTR, 
            `location_trackings`.`campaign_id` as campaign_id, 
            `location_trackings`.`campaign_name` as campaign_name, 
            `location_trackings`.`campaigns_has_ads_group`, 
            DATEDIFF(MAX(`location_trackings`.`date`), MIN(`location_trackings`.`date`)) + 1 as duration"
    )
  end

  after_initialize do
    if new_record?
      self.status = STATUS_PUBLISHED
    end
  end
end
