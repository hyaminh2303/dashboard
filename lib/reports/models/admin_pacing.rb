class Reports::Models::AdminPacing < Reports::Models::AdminCampaign

  attr_reader :group_id
  attr_reader :group_name
  attr_reader :group_target
  attr_reader :group_type
  attr_reader :group_start_date
  attr_reader :group_end_date
  attr_reader :group_target_type
  attr_reader :group_health
  attr_reader :group_pacing

  # attr_accessor :data

  def initialize(detail, options = {}, type = nil)
    super(detail, is_targeted = true, options[:campaign_type])

    @type = type
    unless @type == :sub
      @group_id = detail.group_id
      @group_name = detail.group_name
      @group_target = detail.group_target
      @group_start_date = detail.group_start_date
      @group_end_date = detail.group_end_date
      @group_target_type = options[:campaign_type]
    end
  end

  def hash
    _hash = super()

    unless @type == :sub
      _hash[:group_id] = @group_id
      _hash[:group_name] = @group_name
      _hash[:group_target] = @group_target
      _hash[:group_start_date] = @group_start_date
      _hash[:group_end_date] = @group_end_date
      _hash[:group_health] = @group_health
      _hash[:group_pacing] = @group_pacing
    end
    _hash
  end
end
