class ExchangeRatesGrid

  include Datagrid

  scope do
    Currency
  end

  column(:name, html: true) do |model|
    link_to model.name, currency_path(model)
  end
  column(:code)
  column(:exchange_rate, html: true) do |model|
    MoneyRails.default_bank.get_rate(model.code, :USD)
  end
end
