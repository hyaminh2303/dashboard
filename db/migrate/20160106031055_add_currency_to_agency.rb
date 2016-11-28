class AddCurrencyToAgency < ActiveRecord::Migration
  def change
    add_reference :agencies, :currency, index: true
  end
end
