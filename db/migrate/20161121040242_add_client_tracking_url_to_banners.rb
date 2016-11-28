class AddClientTrackingUrlToBanners < ActiveRecord::Migration
  def change
    add_column(:banners, :client_tracking_url, :string)  unless column_exists?(:banners, :client_tracking_url)
  end
end
