class AddSkipUploadCreativesNeedYooseHelpDesignCreativesToClientBookingCampaigns < ActiveRecord::Migration
  def change
    add_column(:client_booking_campaigns, :skip_upload_creatives, :boolean) unless column_exists?(:client_booking_campaigns, :skip_upload_creatives)
    add_column(:client_booking_campaigns, :need_yoose_help_design_creatives, :boolean) unless column_exists?(:client_booking_campaigns, :need_yoose_help_design_creatives)
    add_column(:client_booking_campaigns, :contact_email, :string) unless column_exists?(:client_booking_campaigns, :contact_email)
  end
end
