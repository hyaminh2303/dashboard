class CurrenciesGrid

  include Datagrid

  scope do
    Currency
  end

  filter(:name, :string)
  filter(:code, :string)

  column(:name, html: true) do |model|
    link_to model.name, currency_path(model)
  end
  column(:code)
  column(:exchange_rate, html: true, header: I18n.t('models.currency.fields.exchange_rate')) do |model|
    begin
      MoneyRails.default_bank.get_rate(model.code, :USD)
    rescue Money::Bank::UnknownRate
      I18n.t('views.currencies.index.unknown_rate')
    end
  end

  column(:actions, :html => true) do |model|
    render :partial => 'currencies/actions', :locals => {:model => model}
  end
end
