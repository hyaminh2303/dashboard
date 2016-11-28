require 'nokogiri'

class AssociationModel
  include ActiveModel::Model
  include ActiveModel::Associations
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Callbacks
  define_model_callbacks :initialize, only: :after

  def initialize(attributes={})
    @present = attributes.present?
    run_callbacks(:initialize) { super }
  end

  def present?
    super && @present
  end

  private

  def valid_associations?(*associations)
    is_valid = true
    associations.each do |a|
      a.each { |m| is_valid &&= m.valid? if m.present? }
    end
    is_valid
  end

  def write_list_to_xml(xml, list, tag_name=nil)
    list.each do |ob|
      ob.xml(xml, tag_name) if ob.present?
    end
  end
end

class Vast < AssociationModel

  CREATIVE_TYPES = [
      PREROLL = 'preroll',
      OVERLAY = 'overlay'
  ]

  attr_accessor :ad_system, :ad_title, :description, :error_urls, :impressions, :linear_ads, :creative_type, :companion_ads, :non_linear_ads, :xml, :url, :has_companion_ad

  validates_presence_of :ad_system, :ad_title, :impressions

  has_many :error_urls
  has_many :impressions
  has_many :linear_ads
  has_many :companion_ads
  has_many :non_linear_ads

  after_initialize do
    @error_urls ||= [ErrorUrl.new]
    @impressions ||= [Impression.new]
    @linear_ads ||= [LinearAd.new]
    @companion_ads ||= [CompanionAd.new]
    @non_linear_ads ||= [NonLinearAd.new]
    @creative_type ||= has_non_linear_ad? ? OVERLAY : PREROLL
    @has_companion_ad ||= has_companion_ad? ? '1' : '0'
  end

  def error_urls_attributes=(attributes)
    if attributes.present?
      @error_urls ||= []
      attributes.each { |i, params| @error_urls.push(ErrorUrl.new(params)) }
    end
  end

  def impressions_attributes=(attributes)
    if attributes.present?
      @impressions ||= []
      attributes.each { |i, params| @impressions.push(Impression.new(params)) }
    end
  end

  def linear_ads_attributes=(attributes)
    if attributes.present?
      @linear_ads ||= []
      attributes.each { |i, params| @linear_ads.push(LinearAd.new(params)) }
    end
  end

  def companion_ads_attributes=(attributes)
    if attributes.present?
      @companion_ads ||= []
      attributes.each { |i, params| @companion_ads.push(CompanionAd.new(params)) }
    end
  end

  def non_linear_ads_attributes=(attributes)
    if attributes.present?
      @non_linear_ads ||= []
      attributes.each { |i, params| @non_linear_ads.push(NonLinearAd.new(params)) }
    end
  end

  before_validation do
    is_valid = valid_associations? @impressions, @linear_ads, @companion_ads, @non_linear_ads
    unless @linear_ads.first.present? || @non_linear_ads.first.present?
      @errors.add(:base, 'Please input at least one of preroll or overlay ads')
      is_valid = false
    end
    is_valid
  end

  def has_ad?
    @linear_ads.first.present? || @non_linear_ads.first.present?
  end

  def has_linear_ad?
    @linear_ads.first.present?
  end

  def has_non_linear_ad?
    @non_linear_ads.first.present?
  end

  def has_companion_ad?
    @companion_ads.first.present?
  end

  def generate(need_commit_to_s3 = false)

    if valid?
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.VAST(version: '2.0'){
          xml.Ad{
            xml.InLine{
              xml.AdSystem ad_system
              xml.AdTitle ad_title
              xml.Description description if description.present?

              write_list_to_xml xml, error_urls, 'Error'

              write_list_to_xml xml, impressions

              write_creatives_to_xml xml

            }
          }
        }
      end

      content_xml = builder.to_xml
      @url = aws_s3_put content_xml if need_commit_to_s3
      @xml = content_xml.lines.to_a[1..-1].join
    end
  end

  private

  def write_creatives_to_xml xml
    xml.Creatives{
      xml.Creative{ #has many creative

        write_list_to_xml xml, linear_ads

        write_companion_ads_to_xml xml

        write_list_to_xml xml, non_linear_ads
      }
    }
  end

  def write_companion_ads_to_xml xml
    if companion_ads.first.present?
      xml.CompanionAds{

        write_list_to_xml xml, companion_ads
      }
    end
  end

  def aws_s3_put(block)
    require 'aws-sdk'
    bucket ||= begin
      AWS.config(
          :access_key_id      => Figaro.env.video_ads_aws_access_key_id,
          :secret_access_key  => Figaro.env.video_ads_aws_secret_access_key,
          :s3_endpoint        => Figaro.env.s3_endpoint
      )
      AWS::S3.new.buckets[Figaro.env.video_ads_bucket]
    end
    s3_obj = "vast/#{ad_title.parameterize('_')}.xml"
    bucket.objects[s3_obj].write(block, acl: :public_read)
    "http://#{Figaro.env.s3_endpoint}/#{Figaro.env.video_ads_bucket}/"+s3_obj
  end

end

class Url < AssociationModel
  attr_accessor :url
  validates :url, url: true

  def xml(builder, name=nil)
    builder.send(name.present? ? name : self.class.to_s){ builder.cdata url } if present?
  end
end

class ErrorUrl < Url
  def present?
    super && url.present?
  end
end

class Impression < Url
  validates_presence_of :url
end

class LinearAd < AssociationModel
  attr_accessor :skipoffset, :duration, :click_through, :click_trackings, :media_files, :tracking_events

  validates_presence_of :duration, :media_files, :click_through
  validates :click_through, url: true

  has_many :click_trackings
  has_many :media_files
  has_many :tracking_events

  after_initialize do
    @click_trackings ||= [ClickTracking.new]
    @media_files ||= [MediaFile.new]
    @tracking_events ||= [TrackingEvent.new]
  end

  def click_trackings_attributes=(attributes)
    if attributes.present?
      @click_trackings ||= []
      attributes.each { |i, params| @click_trackings.push(ClickTracking.new(params)) }
    end
  end

  def media_files_attributes=(attributes)
    if attributes.present?
      @media_files ||= []
      attributes.each { |i, params| @media_files.push(MediaFile.new(params)) }
    end
  end

  def tracking_events_attributes=(attributes)
    if attributes.present?
      @tracking_events ||= []
      attributes.each { |i, params| @tracking_events.push(TrackingEvent.new(params)) }
    end
  end

  before_validation do
    valid_associations? @media_files, @tracking_events
  end

  def xml(builder, name=nil)
    linear_params = {}
    linear_params[:skipoffset] = skipoffset if skipoffset.present?
    builder.Linear(linear_params){
      builder.Duration duration

      write_tracking_events_to_xml builder

      write_video_clicks_to_xml builder

      write_media_files_to_xml builder
    }
  end

  private

  def write_tracking_events_to_xml builder
    builder.TrackingEvents{

      write_list_to_xml builder, tracking_events

    } if tracking_events.first.present?
  end

  def write_video_clicks_to_xml builder
    builder.VideoClicks{

      builder.ClickThrough{ builder.cdata click_through}

      write_list_to_xml builder, click_trackings

    }
  end

  def write_media_files_to_xml builder
    builder.MediaFiles{

      write_list_to_xml builder, media_files

    }
  end

end

class CompanionAd < AssociationModel
  attr_accessor :width, :height, :tracking_events, :click_through, :click_trackings, :ad_resources

  has_many :tracking_events
  has_many :click_trackings
  has_many :ad_resources

  validates_presence_of :ad_resources, :click_through
  validates :width, :height, presence: true, numericality: true
  validates :click_through, url: true

  after_initialize do
    @click_trackings ||= [ClickTracking.new]
    @ad_resources ||= [AdResource.new]
    @tracking_events ||= [TrackingEvent.new]
  end

  def tracking_events_attributes=(attributes)
    if attributes.present?
      @tracking_events ||= []
      attributes.each { |i, params| @tracking_events.push(TrackingEvent.new(params)) }
    end
  end

  def click_trackings_attributes=(attributes)
    if attributes.present?
      @click_trackings ||= []
      attributes.each { |i, params| @click_trackings.push(ClickTracking.new(params)) }
    end
  end

  def ad_resources_attributes=(attributes)
    if attributes.present?
      @ad_resources ||= []
      attributes.each { |i, params| @ad_resources.push(AdResource.new(params)) }
    end
  end

  before_validation do
    valid_associations? @ad_resources, @tracking_events
  end

  def xml(builder, name=nil)
    builder.Companion(width: width, height: height){
      write_list_to_xml builder, ad_resources.each

      builder.CompanionClickThrough{ builder.cdata click_through}

      write_list_to_xml builder, click_trackings, 'CompanionClickTracking'

      write_tracking_events_to_xml builder
    }
  end

  private

  def write_tracking_events_to_xml builder
    builder.TrackingEvents{

      write_list_to_xml builder, tracking_events

    } if tracking_events.first.present?
  end

end

class NonLinearAd < AssociationModel
  attr_accessor :non_linear_resources, :tracking_events

  has_many :tracking_events
  has_many :non_linear_resources

  after_initialize do
    @non_linear_resources ||= [NonLinearResource.new]
    @tracking_events ||= [TrackingEvent.new]
  end

  def tracking_events_attributes=(attributes)
    if attributes.present?
      @tracking_events ||= []
      attributes.each { |i, params| @tracking_events.push(TrackingEvent.new(params)) }
    end
  end

  def non_linear_resources_attributes=(attributes)
    if attributes.present?
      @non_linear_resources ||= []
      attributes.each { |i, params| @non_linear_resources.push(NonLinearResource.new(params)) }
    end
  end

  before_validation do
    valid_associations? @non_linear_resources, @tracking_events
  end

  def xml(builder, name=nil)
    builder.NonLinearAds{
      write_list_to_xml builder, non_linear_resources

      write_tracking_events_to_xml builder
    }
  end

  private

  def write_tracking_events_to_xml builder
    builder.TrackingEvents{

      write_list_to_xml builder, tracking_events

    } if tracking_events.first.present?
  end

end

class NonLinearResource < AssociationModel
  attr_accessor :width, :height, :ad_resources, :click_through, :click_trackings

  has_many :ad_resources
  has_many :click_trackings

  validates_presence_of :click_through
  validates :width, :height, presence: true, numericality: true
  validates :click_through, url: true

  after_initialize do
    @ad_resources ||= [AdResource.new]
    @click_trackings ||= [ClickTracking.new]
  end

  def click_trackings_attributes=(attributes)
    if attributes.present?
      @click_trackings ||= []
      attributes.each { |i, params| @click_trackings.push(ClickTracking.new(params)) }
    end
  end

  def ad_resources_attributes=(attributes)
    if attributes.present?
      @ad_resources ||= []
      attributes.each { |i, params| @ad_resources.push(AdResource.new(params)) }
    end
  end

  before_validation do
    valid_associations? @ad_resources
  end

  def xml(builder, name=nil)
    builder.NonLinear(width: width, height: height){
      write_list_to_xml builder, ad_resources

      builder.NonLinearClickThrough{ builder.cdata click_through}

      write_list_to_xml builder, click_trackings, 'NonLinearClickTracking'
    }
  end

end

class Media < AssociationModel
  extend CarrierWave::Mount

  mount_uploader :media, MediaUploader
  attr_accessor :url
  validates :url, url: true

  validates :url, presence: true, if: 'media.blank?'
  validates :media, presence: true, if: 'url.blank?'

  after_initialize do
    if media.present?
      media.store!
      @url = media.url
    end
  end

  def ext
    if media.present?
      media.file.extension.downcase
    else
      url.from(url.rindex('.')+1)
    end
  end
end

class MediaFile < Media

  MEDIA_TYPES = [
      ['FLV Video', 'video/x-flv'],
      ['MP4 Video', 'video/mp4'],
      ['WMV Video', 'video/x-ms-wmv'],
      ['Flash', 'application/x-shockwave-flash'],
      ['Javascript', 'application/x-Javascript'],
      ['Image (.gif, .jpeg, .png)', 'image']
  ]

  attr_accessor :width, :height, :media_type, :delivery, :bitrate

  validates :width, :height, presence: true, numericality: true
  validates :media_type, presence: true

  def content_type
    (@media_type == 'image') ? "image/#{ext}" : @media_type
  end

  def type=(value)
    if value.start_with?('image')
      @media_type = 'image'
    else
      @media_type = value
    end
  end

  def xml(builder, name=nil)
    builder.MediaFile(delivery: 'progressive', width: width, height: height, type: content_type){ builder.cdata url }
  end
end

class TrackingEvent < Url

  EVENTS = [
      ['Ad creative is viewed', :creativeView],
      ['Start to play Ad creative', :start],
      ['Played for 25% of the duration', :firstQuartile],
      ['Played for 50% of the duration', :midpoint],
      ['Played for 75% of the duration', :thirdQuartile],
      ['Played to the end', :complete],
      ['The mute button is clicked', :mute],
      ['The un-mute button is clicked', :unmute],
      ['The pause/stop button is clicked', :pause],
      ['The rewind button is clicked', :rewind],
      ['The resume button is clicked', :resume],
      ['The video player is expanded to fullscreen', :fullscreen],
      ['The video player is reduced to original size', :exitFullscreen],
      ['The ad creative is expanded', :expand],
      ['The ad creative is reduced to original size', :collapse],
      ['The user launched an additional portion of the creative', :acceptInvitation],
      ['The close button on the creative is clicked', :close],
      ['The skip button to skip the creative is clicked', :skip]
  ]

  attr_accessor :event
  validates_presence_of :url

  def present?
    super && event.present?
  end

  def xml(builder, name=nil)
    builder.Tracking(event: event){ builder.cdata url} if present?
  end
end

class ClickTracking < AssociationModel;
  attr_accessor :url
  validates :url, url: true

  def xml(builder, name=nil)
    builder.send(name.present? ? name : self.class.to_s){ builder.cdata url } if present?
  end

  def present?
    super && url.present?
  end
end

class AdResource < Media

  RESOURCE_TYPES = [
      ['Static', [
                  ['Image (.gif, .jpeg, .png)', 'image'],
                  ['Javascript', 'application/x-javascript'],
                  ['Flash', 'application/x-shockwave-flash']
              ]],
      ['Iframe', [['IFrame Resource', 'iframe']]],
      ['HTML',   [['HTML Resource', 'html']]]
  ]

  attr_accessor :resource_type

  validates_presence_of :resource_type

  def creativeType=(value)
    if value.start_with?('image')
      @resource_type = 'image'
    else
      @resource_type = value
    end
  end

  def creative_type
    (@resource_type == 'image') ? "image/#{ext}" : @resource_type
  end

  def xml(builder, name=nil)
    case resource_type.to_sym
      when :html
        builder.HTMLResource{ builder.cdata url }
      when :iframe
        builder.IFrameResource{ builder.cdata url }
      else
        builder.StaticResource(creativeType: creative_type){ builder.cdata url }
    end if present?
  end
end