module Reports::Helpers::CampaignReportHelper

  def get_ctr(model)
    if model.respond_to?(:views)
      _ctr(model.clicks.to_f, model.views.to_f)
    elsif model.respond_to?(:impressions)
      _ctr(model.clicks.to_f, model.impressions.to_f)
    end

  end

  def get_ctr_impressions(model)
    _ctr(model.clicks.to_f, model.impressions.to_f)
  end

  def get_ctr_by_total(model)
    _ctr(get_total_clicks(model), get_total_views(model))
  end

  def get_ctr_by_total_impressions(model)
    _ctr(get_total_clicks(model), get_total_impressions(model))
  end

  # eCPM =========================================================================
  def get_ecpm(model)
    _ecpm(model.spend, model.views)
  end
  def get_ecpm_by_total_actual_spend(model)
    _ecpm(get_total_actual_spend(model), get_total_views(model))
  end

  # eCPC =========================================================================
  def get_ecpc(model)
    _ecpc(model.spend, model.clicks)
  end
  def get_ecpc_by_total_actual_spend(model)
    _ecpc(get_total_actual_spend(model), get_total_clicks(model))
  end

  def get_total_views(models)
    total models, :views
  end

  def get_total_clicks(models)
    total models, :clicks
  end

  def get_total_impressions(models)
    total models, :impressions
  end

  def get_total_price(models)
    total models, :total_price
  end

  def get_total_number_of_device_ids(models)
    total models, :number_of_device_ids
  end

  def get_total_frequency_cap(models)
    total models, :frequency_cap
  end

  # Get spend inputted
  def get_total_actual_spend(models)
    total models, :spend
  end

  # Spend by computation ===========================================================
  def get_spend(model, campaign)
    if model.respond_to?(:views)
      campaign.CPM? ? model.views * Money.new(campaign.unit_price_in_usd) / 1000 : model.clicks * Money.new(campaign.unit_price_in_usd)
    elsif model.respond_to?(:impressions)
      campaign.CPM? ? model.impressions * Money.new(campaign.unit_price_in_usd) / 1000 : model.clicks * Money.new(campaign.unit_price_in_usd)
    end

  end

  def get_total_spend(models, campaign)
    total = 0
    models.each do |m|
      if m.respond_to?(:impressions)
        total += campaign.CPM? ? m.impressions * Money.new(campaign.unit_price_in_usd).to_f / 1000.0 : m.clicks * Money.new(campaign.unit_price_in_usd).to_f
      else
        total += campaign.CPM? ? m.views * Money.new(campaign.unit_price_in_usd).to_f / 1000.0 : m.clicks * Money.new(campaign.unit_price_in_usd).to_f
      end
    end

    # Total is already in USD
    Currency.usd(total, :USD)
  end

  private
  def _ctr(clicks, views)
    views == 0 ? nil : clicks.to_f / views.to_f
  end

  def _ecpm(spend, views)
    views == 0 ? nil : usd(spend / views * 1000)
  end

  def _ecpc(spend, clicks)
    clicks == 0 ? nil : usd(spend / clicks)
  end

  def total(models, key)
    models.inject(0) { |sum, hash| sum + hash[key] }
  end

  def usd(value)
    if value == BigDecimal::INFINITY
      return I18n.t('statuses.not_available')
    end

    Currency.usd(value, :USD)
  end
end
