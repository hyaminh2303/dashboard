require 'dsp_reporting'

module DailyTrackingsHelper

  class ReportEnumerable
    attr_reader :groups

    def initialize
      @groups = []
    end

    def create_group(group)
      # Create group and add to array if it not exists in array
      if @groups.find {|g| g.id == group.id}.nil?
        g = DspReporting::ReportGroup.new group.name
        g.id = group.id
        @groups << g
      end
    end

    def add_or_append_record(group_id, record)
      group_index = @groups.find_index {|g| g.id == group_id}

      if group_index.nil?
        return
      end

      record_index = @groups[group_index].records.find_index {|r| r.date == record.date}

      if record_index.nil?
        @groups[group_index].records << record
      else
        @groups[group_index].records[record_index].views += record.views
        @groups[group_index].records[record_index].clicks += record.clicks
        @groups[group_index].records[record_index].spend += record.spend
      end
    end
  end

  def import_for_normal(platform, groups)
    # Init variables
    success = 0
    errors = []
    errors_messages = []
    skips = []
    unprocessed_groups = {:count => 0, :groups => [], :total_record => 0}

    import_params[:file].each do |f|
      # Read file using ReportReader
      report = read_file f, platform, groups

      # Import ReportResult to DB
      result = import_report_result platform, report[:report_result]
      success += result[:success]
      errors += result[:errors]
      errors_messages += result[:errors_messages]
      skips += result[:skips]

      # Process unprocessed groups
      upg = get_unprocessed_groups_data(report[:report_reader].unprocessed_groups)
      unprocessed_groups[:count] += upg[:count]
      unprocessed_groups[:groups] += upg[:groups]
      unprocessed_groups[:total_record] += upg[:total_record]
    end

    {
        success: success,
        errors: errors,
        errors_messages: errors_messages,
        skips: skips,
        unprocessed_groups: unprocessed_groups
    }
  end

  def import_for_sum(platform, groups)
    unprocessed_groups = {:count => 0, :groups => [], :total_record => 0}
    report_enum = DailyTrackingsHelper::ReportEnumerable.new

    import_params[:file].each do |f|
      # Read file using ReportReader
      report = read_file f, platform, groups

      # This difference from import_for_normal method
      # Sum record by group & date
      report[:report_result].each do |group|
        report_enum.create_group group
        group.records.each do |record|
          report_enum.add_or_append_record group.id, record
        end
      end

      # Process unprocessed groups
      upg = get_unprocessed_groups_data(report[:report_reader].unprocessed_groups)
      unprocessed_groups[:count] += upg[:count]
      unprocessed_groups[:groups] += upg[:groups]
      unprocessed_groups[:total_record] += upg[:total_record]
    end

    # Import ReportResult in report_enum to DB
    result = import_report_result platform, report_enum.groups

    result.merge unprocessed_groups: unprocessed_groups
  end

  private
  # Upload file and using DspReporting to read
  # @return {ReportReader,ReportResult}
  def read_file(file, platform, groups)
    uploader = DailyTrackingUploader.new
    uploader.store!(file)

    reader = DspReporting::ReportReader.new("#{Rails.public_path}#{uploader.url}", platform.report_settings, groups)
    {
        report_result: reader.read.result,
        report_reader: reader
    }
  end

  def import_report_result(platform, report_result)
    success = 0
    errors = []
    errors_messages = []
    skips = []

    now_time_i = Date.yesterday.to_time.to_i

    report_result.each do |group|
      group.records.each do |record|
        db_record = DailyTracking.where(campaign_id: @campaign.id, platform_id: platform.id, group_id: group.id, date: record.date).first
        if !db_record.nil? and import_override?
          db_record.views = record.views
          db_record.clicks = record.clicks
          db_record.spend = record.spend
        else
          if db_record.nil? and record.date.to_time.to_i <= now_time_i
            db_record = DailyTracking.new(
                {
                    campaign: @campaign,
                    platform: platform,
                    group_id: group.id,
                    date: record.date,
                    views: record.views,
                    clicks: record.clicks,
                    spend: record.spend
                }
            )
          else
            skips << record
            next
          end
        end
        if db_record.save
          success += 1
        else
          errors << db_record.errors
          errors_messages << get_errors_messages(db_record)
        end
      end
    end

    {
        success: success,
        errors: errors,
        errors_messages: errors_messages,
        skips: skips
    }
  end
end
