module CampaignHealth
  def sum_daily
    @sum_daily =  DailyTracking.select('SUM(views) as views, SUM(clicks) as clicks').where(campaign_id: id).first
  end

  def delivery_of_target
    delivery_realized
  end

  def total_days
    (expire_at - active_at).to_i + 1
  end

  def days_left
    (expire_at - Date.today).to_i + 1
  end

  def delivery_realized
    get_delivery_realized(@sum_daily.views, @sum_daily.clicks)
  end

  def delivery_expected
    get_delivery_expected
  end

  def health
    get_health delivery_realized, delivery_expected
  end

  def delivery_realized_percent
    (delivery_realized * 100).round(2)
  end

  def delivery_expected_percent
    (delivery_expected * 100).round(2)
  end

  def health_percent
    (health * 100).round(2)
  end

  def daily_pacing
    if Time.now.to_date < active_at.to_date
      # Future campaign
      days = (expire_at.to_date - active_at.to_date + 1).to_i
    elsif Time.now.to_date > expire_at.to_date
      # Past campaign
      return 0
    else
      days = (expire_at.to_date - Time.now.to_date + 1).to_i
    end

    remaining = self.target - (CPM? ? @sum_daily.views.to_i : @sum_daily.clicks.to_i)
    days == 0 ? remaining.to_f / 1 : remaining.to_f / days.to_f
  end

  private
  def get_delivery_realized(total_views, total_clicks)
    value = CPM? ? total_views : total_clicks
    self.target == 0 ? 0.0 : value.to_f / target.to_f
  end

  def get_delivery_expected
    if self.target == 0
      return 0.0
    end

    if Time.now.to_date > expire_at.to_date
      return 1.0
    elsif Time.now.to_date < active_at.to_date
      return 0.0
    end

    _target = self.target.to_f
    number_of_day = (expire_at.to_date - active_at.to_date + 1).to_i.to_f
    days_left = (expire_at.to_date - Time.now.to_date + 1).to_i.to_f

    ((_target / number_of_day) * (number_of_day - days_left)) / _target
  end

  def get_health(realized, expected)
    realized - expected
  end
end
