module CampaignReportsHelper

  def admin_row_campaign_info(current_line, model = nil)
    case current_line
      when 1
        [
            '', '', '', '', '', '', '', '', '',
            t('views.campaign_reports.workbook.fields.start_date'),
            t('views.campaign_reports.workbook.fields.end_date'),
            t('views.campaign_reports.workbook.fields.exchange_rate'),
            model.campaign_type, '',
            t('views.campaign_reports.workbook.fields.media_budget'), ''
        ]
      when 2
        [
            '', '',
            model.active_at.strftime(Date::DATE_FORMATS[:iso]),
            model.expire_at.strftime(Date::DATE_FORMATS[:iso]),
            model.exchange_rate.nil? ? MoneyRails.default_bank.get_rate(model.unit_price_currency, Money.default_currency) : model.exchange_rate,
            get_unit_price(model, :local).format, get_unit_price(model, :global).format,
            get_budget(model, :local).format, get_budget(model, :global).format
        ]
      else
        []
    end
  end

  def agency_row_campaign_info(current_line, model = nil)
    case current_line
      when 1
        [
            '', '', '', '', '',
            t('views.campaign_reports.workbook.fields.start_date'),
            t('views.campaign_reports.workbook.fields.end_date'),
            model.campaign_type,
            t('views.campaign_reports.workbook.fields.media_budget')
        ]
      when 2
        [
            '',
            model.active_at.strftime(Date::DATE_FORMATS[:iso]),
            model.expire_at.strftime(Date::DATE_FORMATS[:iso]),
            get_unit_price(model, :global),
            get_budget(model, :global)
        ]
      else
        []
    end
  end

  def admin_style_campaign_info(current_line)
    case current_line
      when 1
        [ @title, @title, @title, @title, @title, @title, @title, @title, nil, nil, @title_with_border, @title_with_border, @title_with_border, @title_with_border, @title_with_border, @title_with_border, @title_with_border]
      when 2
        [ nil, nil, @border, @border, @border, @border, @border, @border, @border]
      else
    end
  end

  def agency_style_campaign_info(current_line)
    case current_line
      when 1
        [ @title, @title, @title, @title, @title, nil, @title_with_border, @title_with_border, @title_with_border, @title_with_border]
      when 2
        [ nil, @border, @border, @border_money, @border_money]
      else
    end
  end

  def admin_campaign_health_title
    [
        '', '', '', '', '', '', '',
        t('views.campaign_details.fields.delivery_realized'),
        t('views.campaign_details.fields.delivery_expected'),
        t('views.campaign_details.fields.campaign_health'),
        t('views.campaign_details.fields.daily_pacing')
    ]
  end

  def agency_campaign_health_title
    [
        '',
        t('views.campaign_details.fields.delivery_realized'),
        t('views.campaign_details.fields.delivery_expected'),
        t('views.campaign_details.fields.campaign_health'),
        t('views.campaign_details.fields.daily_pacing')
    ]
  end

  def admin_campaign_health_style
    [ nil, nil, nil, nil, nil, nil, nil, nil, @title_with_border, @title_with_border, @title_with_border, @title_with_border]
  end

  def agency_campaign_health_style
    [ nil, @title_with_border, @title_with_border, @title_with_border, @title_with_border]
  end

  def admin_campaign_health_content(campaign)
    [
        '', '',
        number_to_percentage(campaign.delivery_realized_percent, precision: 2),
        number_to_percentage(campaign.delivery_expected_percent, precision: 2),
        number_to_percentage(campaign.health_percent, precision: 2),
        number_with_delimiter(campaign.daily_pacing.round(3))
    ]
  end

  def admin_campaign_health_content_style
    [ nil, nil, @border, @border, @border, @border]
  end

  def agency_campaign_health_content(campaign)
    [
        '',
        number_to_percentage(campaign.delivery_realized_percent, precision: 2),
        number_to_percentage(campaign.delivery_expected_percent, precision: 2),
        number_to_percentage(campaign.health_percent, precision: 2),
        number_with_delimiter(campaign.daily_pacing.round(3))
    ]
  end

  def agency_campaign_health_content_style
    [ nil, @border, @border, @border, @border]
  end

  def get_unit_price(campaign, type)
    type == :local ? Money.new(campaign.unit_price_cents, campaign.unit_price_currency) : campaign.unit_price_in_usd_as_money
  end

  def get_budget(campaign, type)
    if type == :global
      return campaign.budget_as_money
    end

    if campaign.exchange_rate.blank?
      Currency.money(campaign.budget_as_money.to_f, :USD).exchange_to(campaign.unit_price_currency)
    else
      (campaign.budget_as_money.to_f / campaign.exchange_rate).to_money(campaign.unit_price_currency)
    end
  end

  private

  def get_cents(campaign)
    campaign.unit_price_cents.to_f / 100.0
  end
end
