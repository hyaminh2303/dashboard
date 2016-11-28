class LocationTracking < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :location

  validates :date, presence: true
  validate :date_between_campaign_start_end

  validates :campaign, :location, :views, :clicks, presence: true # :views, :clicks used when update
  # validates :views, :numericality => { :greater_than => 0 }, if: :clicks_greater_than_zero?
  # validates :clicks, :numericality => { :greater_than => 0 }, if: :views_greater_than_zero?

  validate :unique_log

  # def clicks_greater_than_zero?
  #   clicks == 0
  # end
  #
  # def views_greater_than_zero?
  #   views == 0
  # end

  scope :by_date, ->(date) { where(date: date)}
  scope :select_by_campaign, ->(campaign_id) { where(campaign_id: campaign_id) if campaign_id.to_i > 0 }
  scope :select_in_period, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :belong_to, ->(user) { joins(:campaign).where(campaigns: {agency_id: user.agency.id}) if (user.present? && user.is_agency_or_client?)}

  #------------------------------- begin instances ---------------------------------#
  # Custom validation
  def unique_log
    if self.new_record?
      unless LocationTracking.where(:campaign_id => campaign_id, :location_id => location_id, :date => date).count == 0
        errors.add(:location_tracking, I18n.t('models.location_tracking.validate.already_add'))
      end
    end
  end

  # validate date
  def date_between_campaign_start_end
    if date.nil? || date < campaign.active_at || date > campaign.expire_at
      errors.add(:campaign, I18n.t('models.location_tracking.validate.not_running_date'))
    end
  end

  # @author The Anh
  # @date 180420
  def self.search_by_keyword(keyword = nil)
    location_trackings = self
    # search by keyword
    if !keyword.nil? && keyword.strip.length > 0
      tokens = keyword.gsub('、', ',').split(',').collect {|c| "%#{c.downcase.strip}%"}
      arr_filter_columns = ['`location_trackings`.`name`']
      location_trackings = location_trackings.where(((["CONCAT_WS(' ', " + arr_filter_columns.join(', ') + ') LIKE ?']*tokens.size).join(' OR ')),*(tokens).collect{ |token| [token] }.flatten)
    end
    return location_trackings
  end

  def self.search(keyword = nil, user = nil)
    location_trackings = self
    st_join = "INNER JOIN `campaigns` ON `campaigns`.`id` = `location_trackings`.`campaign_id`"

    # check permission
    case
    when user.is_client?
      st_join = "INNER JOIN (SELECT * from `campaigns` where `campaigns`.`user_id` = #{user.id}) as campaigns ON `campaigns`.`id` = `location_trackings`.`campaign_id`"
    when user.is_agency?
      # get client account
      agency = Agency.find_by(:user_id => user.id)
      at_client_id = agency.clients.collect{|agency| "'" + agency.user_id.to_s + "'"}.join(',')
      at_client_id = "('" + user.id.to_s + "'" + ',' + at_client_id + ")"
      st_join = "INNER JOIN (SELECT * from `campaigns` where `campaigns`.`user_id` in #{at_client_id}) as campaigns ON `campaigns`.`id` = `location_trackings`.`campaign_id`"
    else
      st_join = "INNER JOIN `campaigns` ON `campaigns`.`id` = `location_trackings`.`campaign_id`"
    end

    location_trackings.search_by_keyword(keyword).joins(st_join)
    .group("`location_trackings`.`name`, `location_trackings`.`campaign_id`")
    .order("`location_trackings`.`name`, `location_trackings`.`campaign_id`")
    .select("`location_trackings`.`location_id` as location_id, 
            `location_trackings`.`name` as name, 
            sum(`location_trackings`.`views`) as views_count, 
            sum(`location_trackings`.`clicks`) as clicks_count, 
            100 * sum(`location_trackings`.`clicks`) / sum(`location_trackings`.`views`) as ctr_count, 
            `location_trackings`.`campaign_id` as campaign_id, 
            `campaigns`.`name` as campaign_name, 
            `campaigns`.`has_ads_group`, 
            DATEDIFF(MAX(`location_trackings`.`date`), MIN(`location_trackings`.`date`)) + 1 as duration"
    )
  end

  # Callback functions
  after_initialize do
    if self.new_record?
      # This used for create new
      self.views  = 0 if self.views.blank?
      self.clicks = 0 if self.clicks.blank?
      if self.views == 0
        self.ctr = 0
      else
        self.ctr = 100.0 * self.clicks / self.views
      end
    end
  end
end
