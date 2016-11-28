json.extract! @order, :id, :created_at, :sale_manager_id, :agency_id, :user_id, :campaign_name, :advertiser_name, :additional_information, :authorization, :date, :currency_id
json.order_items @order.order_items, :id, :country, :ad_format, :banner_size, :placement, :start_time, :end_time, :rate_type, :target_clicks_or_impressions, :unit_cost, :total_budget
json.sub_totals @order.sub_totals, :id, :order_id, :sub_total_setting_id, :value, :sub_total_type
json.agency_currency @order.agency.currency.name
json.billing_currency @order.currency.name
