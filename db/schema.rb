# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161121074530) do

  create_table "advertisers", force: true do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "email"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "age_range_dsp_mapping", force: true do |t|
    t.integer "age_range_id"
    t.integer "dsp_id"
    t.integer "age_range_dsp_id"
    t.string  "age_range_code"
  end

  add_index "age_range_dsp_mapping", ["age_range_id"], name: "index_age_range_dsp_mapping_on_age_range_id", using: :btree

  create_table "age_ranges", force: true do |t|
    t.string "age_range_code"
    t.string "name"
  end

  create_table "agencies", force: true do |t|
    t.string   "name"
    t.string   "country_code",     limit: 2
    t.string   "email"
    t.integer  "user_id"
    t.boolean  "enabled",                    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "phone"
    t.string   "address"
    t.string   "billing_name"
    t.string   "billing_phone"
    t.string   "billing_address"
    t.string   "billing_email"
    t.integer  "currency_id"
    t.boolean  "use_contact_info",           default: false
    t.string   "channel"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_address"
    t.string   "contact_email"
    t.boolean  "hide_finance",               default: false
  end

  add_index "agencies", ["currency_id"], name: "index_agencies_on_currency_id", using: :btree

  create_table "app_categories", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_trackings", force: true do |t|
    t.integer  "campaign_id"
    t.string   "name"
    t.date     "date"
    t.integer  "views",       default: 0
    t.integer  "clicks",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_trackings", ["campaign_id"], name: "index_app_trackings_on_campaign_id", using: :btree

  create_table "banner_sizes", force: true do |t|
    t.string "name"
    t.string "size"
  end

  create_table "banner_type_dsp_mapping", force: true do |t|
    t.integer "banner_type_id"
    t.integer "dsp_id"
    t.integer "banner_type_dsp_id"
    t.string  "banner_type_code"
  end

  add_index "banner_type_dsp_mapping", ["banner_type_id"], name: "index_banner_type_dsp_mapping_on_banner_type_id", using: :btree

  create_table "banner_types", force: true do |t|
    t.string "name"
    t.string "banner_type_code"
  end

  create_table "banners", force: true do |t|
    t.integer  "client_booking_campaign_id"
    t.text     "name"
    t.text     "landing_url"
    t.text     "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_tracking_url"
  end

  create_table "booking_campaigns", force: true do |t|
    t.string   "banner_type"
    t.string   "banner_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_ads_groups", force: true do |t|
    t.integer  "campaign_id",              null: false
    t.string   "name",        default: "", null: false
    t.string   "keyword"
    t.string   "description", default: ""
    t.integer  "target"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_ads_groups", ["campaign_id"], name: "index_campaign_ads_groups_on_campaign_id", using: :btree

  create_table "campaign_type_dsp_mapping", force: true do |t|
    t.integer "campaign_type_id"
    t.integer "dsp_id"
    t.integer "campaign_type_dsp_id"
    t.string  "campaign_type_code"
  end

  add_index "campaign_type_dsp_mapping", ["campaign_type_id"], name: "index_campaign_type_dsp_mapping_on_campaign_type_id", using: :btree

  create_table "campaign_types", force: true do |t|
    t.string "name"
    t.string "campaign_type_code"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.integer  "agency_id"
    t.string   "country_code",            limit: 2
    t.string   "advertiser_name"
    t.integer  "advertiser_id"
    t.date     "active_at"
    t.date     "expire_at"
    t.integer  "target_click",                                                default: 0
    t.integer  "target_impression",                                           default: 0
    t.integer  "revenue_type",                                                default: 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_price_cents",                                            default: 0,     null: false
    t.string   "unit_price_currency",                                         default: "USD", null: false
    t.boolean  "has_location_breakdown"
    t.boolean  "has_ads_group",                                               default: false, null: false
    t.boolean  "target_per_ad_group",                                         default: false
    t.float    "exchange_rate",           limit: 24
    t.integer  "category_id"
    t.integer  "unit_price_in_usd"
    t.integer  "budget"
    t.decimal  "discount",                           precision: 5,  scale: 2
    t.integer  "bonus_impression"
    t.text     "remark"
    t.string   "sales_agency_commission"
    t.string   "campaign_key"
    t.decimal  "development_fee",                    precision: 10, scale: 2
    t.string   "campaign_manager"
    t.boolean  "is_notified",                                                 default: false
    t.string   "signed_io"
    t.boolean  "is_attached_io",                                              default: false
    t.date     "last_stats_at"
    t.integer  "user_notify_id"
    t.boolean  "apply_price_creative",                                        default: false
  end

  add_index "campaigns", ["agency_id"], name: "index_campaigns_on_agency_id", using: :btree
  add_index "campaigns", ["category_id"], name: "index_campaigns_on_category_id", using: :btree
  add_index "campaigns", ["user_notify_id"], name: "index_campaigns_on_user_notify_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "category_code"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_dsp_mapping", force: true do |t|
    t.integer "category_id"
    t.integer "dsp_id"
    t.integer "category_dsp_id"
    t.string  "category_code"
    t.integer "parent_id"
  end

  add_index "category_dsp_mapping", ["category_id"], name: "index_category_dsp_mapping_on_category_id", using: :btree

  create_table "client_booking_campaigns", force: true do |t|
    t.string   "banner_type"
    t.string   "banner_size"
    t.text     "description"
    t.boolean  "no_specific_locations",                       default: false
    t.string   "campaign_name"
    t.string   "advertiser_name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "timezone"
    t.string   "campaign_category"
    t.integer  "frequency_cap"
    t.string   "campaign_type"
    t.integer  "target"
    t.float    "unit_price",                       limit: 24
    t.float    "budget",                           limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code"
    t.text     "ad_tag"
    t.text     "time_schedule"
    t.text     "carrier"
    t.string   "wifi_or_cellular"
    t.string   "os"
    t.string   "app_category"
    t.text     "additional"
    t.integer  "status",                                      default: 0
    t.boolean  "skip_upload_creatives"
    t.boolean  "need_yoose_help_design_creatives"
    t.string   "contact_email"
  end

  create_table "client_booking_locations", force: true do |t|
    t.string   "name"
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.integer  "place_id"
    t.float    "radius",     limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "country_code", null: false
    t.string   "name",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_costs", force: true do |t|
    t.string "country_code"
    t.string "country_name"
    t.float  "population",   limit: 24
    t.float  "cpc",          limit: 24
    t.float  "cpm",          limit: 24
  end

  create_table "country_dsp_mapping", force: true do |t|
    t.integer "country_id"
    t.integer "dsp_id"
    t.integer "country_dsp_id"
    t.string  "country_code"
  end

  add_index "country_dsp_mapping", ["country_id"], name: "index_country_dsp_mapping_on_country_id", using: :btree

  create_table "creative_trackings", force: true do |t|
    t.string   "name",        limit: 256, null: false
    t.integer  "campaign_id",             null: false
    t.date     "date",                    null: false
    t.integer  "impressions",             null: false
    t.integer  "clicks",                  null: false
    t.datetime "updated_at",              null: false
    t.datetime "created_at",              null: false
    t.float    "unit_price",  limit: 24
  end

  create_table "currencies", force: true do |t|
    t.string "name"
    t.string "code", limit: 3
  end

  create_table "daily_est_imps", force: true do |t|
    t.string  "country_code"
    t.string  "country_name"
    t.integer "banner_size_id"
    t.string  "banner_size"
    t.float   "impression",     limit: 24
  end

  add_index "daily_est_imps", ["country_code", "banner_size_id"], name: "daily_est_imps_country_code_banner_size", using: :btree

  create_table "daily_trackings", force: true do |t|
    t.integer "campaign_id"
    t.integer "platform_id"
    t.date    "date"
    t.integer "views",                                default: 0,   null: false
    t.integer "clicks",                               default: 0,   null: false
    t.decimal "spend",       precision: 19, scale: 4, default: 0.0, null: false
    t.integer "group_id"
  end

  add_index "daily_trackings", ["campaign_id"], name: "index_daily_trackings_on_campaign_id", using: :btree
  add_index "daily_trackings", ["group_id"], name: "index_daily_trackings_on_group_id", using: :btree
  add_index "daily_trackings", ["platform_id"], name: "index_daily_trackings_on_platform_id", using: :btree

  create_table "densities", force: true do |t|
    t.string "country_code"
    t.string "city_name"
    t.float  "density",      limit: 24
    t.float  "population",   limit: 24
    t.float  "area",         limit: 24
  end

  add_index "densities", ["city_name"], name: "index_densities_on_city_name", using: :btree
  add_index "densities", ["country_code"], name: "index_densities_on_country_code", using: :btree

  create_table "device_trackings", force: true do |t|
    t.integer  "campaign_id",                      null: false
    t.integer  "campaign_ads_group_id"
    t.integer  "views",                            null: false
    t.integer  "clicks",                           null: false
    t.integer  "number_of_device_ids",             null: false
    t.integer  "frequency_cap",                    null: false
    t.datetime "updated_at",                       null: false
    t.datetime "created_at",                       null: false
    t.date     "date",                             null: false
    t.string   "date_range",            limit: 32, null: false
  end

  create_table "gender_dsp_mapping", force: true do |t|
    t.integer "gender_id"
    t.integer "dsp_id"
    t.integer "gender_dsp_id"
    t.string  "gender_code"
  end

  add_index "gender_dsp_mapping", ["gender_id"], name: "index_gender_dsp_mapping_on_gender_id", using: :btree

  create_table "genders", force: true do |t|
    t.string "name"
    t.string "gender_code"
  end

  create_table "interest_dsp_mapping", force: true do |t|
    t.integer "interest_id"
    t.integer "dsp_id"
    t.integer "interest_dsp_id"
    t.string  "interest_code"
  end

  add_index "interest_dsp_mapping", ["interest_id"], name: "index_interest_dsp_mapping_on_interest_id", using: :btree

  create_table "interests", force: true do |t|
    t.string "interest_code"
    t.string "name"
  end

  create_table "location_lists", force: true do |t|
    t.string   "name"
    t.string   "list_type"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_lists_locations", force: true do |t|
    t.integer "location_id"
    t.integer "location_list_id"
  end

  create_table "location_trackings", force: true do |t|
    t.string   "name"
    t.integer  "campaign_id",                          null: false
    t.date     "date",                                 null: false
    t.integer  "location_id",                          null: false
    t.integer  "views",                  default: 0,   null: false
    t.integer  "clicks",                 default: 0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ctr",         limit: 24, default: 0.0, null: false
  end

  add_index "location_trackings", ["campaign_id"], name: "index_location_trackings_on_campaign_id", using: :btree
  add_index "location_trackings", ["location_id"], name: "index_location_trackings_on_location_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "zip_code"
    t.string   "country_code"
    t.decimal  "longitude",    precision: 11, scale: 8, default: 0.0, null: false
    t.decimal  "latitude",     precision: 11, scale: 8, default: 0.0, null: false
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_systems", force: true do |t|
    t.string "operating_system_code"
    t.string "name"
  end

  create_table "order_items", force: true do |t|
    t.string   "country"
    t.string   "ad_format"
    t.string   "banner_size"
    t.string   "placement"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "rate_type"
    t.integer  "target_clicks_or_impressions"
    t.float    "unit_cost",                    limit: 24
    t.float    "total_budget",                 limit: 24
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_settings", force: true do |t|
    t.text     "key"
    t.text     "value"
    t.integer  "setting_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
    t.integer  "sale_manager_id"
    t.string   "campaign_name"
    t.string   "advertiser_name"
    t.text     "additional_information"
    t.text     "authorization"
    t.float    "total_budget",           limit: 24
    t.datetime "date"
    t.integer  "currency_id"
  end

  add_index "orders", ["currency_id"], name: "index_orders_on_currency_id", using: :btree

  create_table "os", force: true do |t|
    t.string "os_code"
    t.string "name"
  end

  create_table "os_dsp_mapping", force: true do |t|
    t.integer "operating_system_id"
    t.integer "dsp_id"
    t.integer "operating_system_dsp_id"
    t.string  "operating_system_code"
  end

  add_index "os_dsp_mapping", ["operating_system_id"], name: "index_os_dsp_mapping_on_operating_system_id", using: :btree

  create_table "os_trackings", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id",         null: false
    t.date     "date",                null: false
    t.integer  "operating_system_id", null: false
    t.integer  "views",               null: false
    t.integer  "clicks",              null: false
  end

  create_table "permissions", force: true do |t|
    t.string  "name"
    t.string  "subject_class"
    t.integer "subject_id"
    t.string  "action"
    t.text    "description"
  end

  create_table "places", force: true do |t|
    t.string   "country"
    t.string   "city"
    t.integer  "client_booking_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "platforms", force: true do |t|
    t.string   "name"
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publishers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string  "name"
    t.boolean "super_admin", default: false
    t.boolean "system_role", default: false
    t.string  "key"
  end

  create_table "roles_permissions", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  add_index "roles_permissions", ["permission_id"], name: "index_roles_permissions_on_permission_id", using: :btree
  add_index "roles_permissions", ["role_id", "permission_id"], name: "index_roles_permissions_on_role_id_and_permission_id", using: :btree

  create_table "sale_managers", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "sub_total_settings", force: true do |t|
    t.string   "name"
    t.float    "value",                  limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sub_total_setting_type"
  end

  create_table "sub_totals", force: true do |t|
    t.integer  "order_id"
    t.float    "value",                limit: 24
    t.float    "budget",               limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sub_total_setting_id"
    t.integer  "sub_total_type"
  end

  create_table "timezone_dsp_mapping", force: true do |t|
    t.integer "timezone_id"
    t.integer "dsp_id"
    t.integer "timezone_dsp_id"
    t.string  "timezone_code"
  end

  add_index "timezone_dsp_mapping", ["timezone_id"], name: "index_timezone_dsp_mapping_on_timezone_id", using: :btree

  create_table "timezones", force: true do |t|
    t.string "timezone_code"
    t.string "name"
    t.string "zone"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "locale",                 default: "en"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

end
