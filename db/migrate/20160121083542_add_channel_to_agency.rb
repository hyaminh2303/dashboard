class AddChannelToAgency < ActiveRecord::Migration
  def change
    add_column :agencies, :channel, :string
  end
end
